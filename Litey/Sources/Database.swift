//
//  Database.swift
//  Litey
//
//  Created by Yu Tawata on 2020/08/10.
//

import Foundation
import SQLite3

public typealias RawConnection = OpaquePointer
public typealias RawStatement = OpaquePointer

public struct Column<V> where V: Value {
    let name: String

    public init(_ name: String) {
        self.name = name
    }
}

public enum RowError: Error {
    case notFoundColumn
    case differentDataType
}

public class Row {
    public enum Value: Equatable {
        case int64(Int64)
        case double(Double)
        case string(String)
    }

    private let names: [String]
    private let values: [Value?]

    init(statement: RawStatement) {
        var names = [String]()
        var values = [Value?]()

        for i in 0 ..< sqlite3_column_count(statement) {
            names.append(String(cString: UnsafePointer(sqlite3_column_name(statement, i))))

            let code = sqlite3_column_type(statement, i)

            switch code {
            case SQLITE_NULL:
                values.append(.none)
            case SQLITE_INTEGER:
                values.append(.int64(sqlite3_column_int64(statement, i)))
            case SQLITE_FLOAT:
                values.append(.double(sqlite3_column_double(statement, i)))
            case SQLITE_TEXT:
                values.append(.string(String(cString: UnsafePointer(sqlite3_column_text(statement, i)))))
            default:
                fatalError("Unsupport column type: \(code).")
            }
        }

        self.names = names
        self.values = values
    }

    public subscript(idx: Int) -> Value? {
        values[idx]
    }
}

extension Row {
    public func get<V>(_ column: Column<V>) throws -> V {
        guard let i = names.firstIndex(of: column.name) else {
            throw RowError.notFoundColumn
        }

        if let value = values[i] as? V {
            return value
        } else {
            throw RowError.differentDataType
        }
    }
}

extension Row: Sequence {
    public func makeIterator() -> AnyIterator<Value?> {
        var i = 0
        return AnyIterator {
            defer { i += 1 }

            return i < self.values.count
                ? self.values[i]
                : Optional<Value?>.none
        }
    }
}

public class Statement {
    let connection: RawConnection
    let statement: RawStatement

    init(statement: RawStatement, on connection: RawConnection) {
        self.connection = connection
        self.statement = statement
    }

    deinit {
        sqlite3_finalize(statement)
    }
}

public struct StatementIterator: IteratorProtocol {
    private let connection: RawConnection
    private let statement: RawStatement

    init(statement: RawStatement, connection: RawConnection) {
        self.connection = connection
        self.statement = statement
    }

    public mutating func next() -> Row? {
        if sqlite3_step(statement) == SQLITE_ROW {
            return Row(statement: statement)
        } else {
            return .none
        }
    }
}

extension Statement: Sequence {
    public func makeIterator() -> StatementIterator {
        StatementIterator(statement: statement, connection: connection)
    }
}

public enum DatabaseError: Error {
    case open(path: String)
    case exec(code: Int32)
}

public class Database {
    private let queue = DispatchQueue(label: "litey.database")

    private let connection: RawConnection

    init(connection: RawConnection) {
        self.connection = connection
    }

    deinit {
        sqlite3_close_v2(connection)
    }

    public static func connect(path: String) throws -> Database {
        let (connection, code): (RawConnection?, Int32) = {
            var connection: RawConnection?
            let code = sqlite3_open_v2(path, &connection, (SQLITE_OPEN_READWRITE | SQLITE_OPEN_CREATE | SQLITE_OPEN_FULLMUTEX), nil)
            return (connection, code)
        }()

        if code == SQLITE_OK, let connection = connection {
            return Database(connection: connection)
        } else {
            throw DatabaseError.open(path: path)
        }
    }

    public func execute(_ sql: String, completion: (Result<Statement, DatabaseError>) -> Void) {
        queue.sync {
            var statement: RawStatement?
            let code = sqlite3_prepare_v2(connection, sql, -1, &statement, .none)

            if code == SQLITE_OK, let statement = statement {
                completion(.success(.init(statement: statement, on: connection)))
            } else {
                completion(.failure(.exec(code: code)))
            }
        }
    }
}
