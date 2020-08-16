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

public class Item {
    let names: [String]
    let values: [Value?]

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
                values.append(sqlite3_column_int64(statement, i))
            case SQLITE_FLOAT:
                values.append(sqlite3_column_double(statement, i))
            case SQLITE_TEXT:
                values.append(String(cString: UnsafePointer(sqlite3_column_text(statement, i))))
            case SQLITE_BLOB:
                if let bytes = sqlite3_column_blob(statement, i) {
                    let count = Int(sqlite3_column_bytes(statement, i))
                    values.append(Data(bytes: bytes, count: count))
                } else {
                    values.append(Data())
                }
            default:
                fatalError("Unsupport column type: \(code).")
            }
        }

        self.names = names
        self.values = values
    }

    public subscript(idx: Int) -> Int64? {
        values[idx] as? Int64
    }

    public subscript(idx: Int) -> Double? {
        values[idx] as? Double
    }

    public subscript(idx: Int) -> String? {
        values[idx] as? String
    }

    public subscript(idx: Int) -> Data? {
        values[idx] as? Data
    }
}

public enum ItemError: Error {
    case notFoundColumn
    case differentDataType
}

extension Item {
    public func get<V>(_ idx: Int) throws -> V {
        if let value = values[idx] as? V {
            return value
        } else {
            throw ItemError.differentDataType
        }
    }
}

extension Item: Sequence {
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

    public mutating func next() -> Item? {
        if sqlite3_step(statement) == SQLITE_ROW {
            return Item(statement: statement)
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

public enum Location {
    case memory
    case temporary
    case path(String)

    var filename: String {
        switch self {
        case .memory:
            return ":memory:"
        case .temporary:
            return ""
        case .path(let raw):
            return raw
        }
    }
}

public enum DatabaseError: Error {
    case open(location: Location)
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

    public static func connect(location: Location) throws -> Database {
        let (connection, code): (RawConnection?, Int32) = {
            var connection: RawConnection?
            let code = sqlite3_open_v2(location.filename, &connection, (SQLITE_OPEN_READWRITE | SQLITE_OPEN_CREATE | SQLITE_OPEN_FULLMUTEX), nil)
            return (connection, code)
        }()

        if code == SQLITE_OK, let connection = connection {
            return Database(connection: connection)
        } else {
            throw DatabaseError.open(location: location)
        }
    }

    public func execute(_ sql: String) throws {
        try queue.sync(flags: .barrier) { () -> Void in
            let code = sqlite3_exec(connection, sql, .none, .none, .none)

            if code == SQLITE_OK {
                return ()
            } else {
                throw DatabaseError.exec(code: code)
            }
        }
    }

    @discardableResult
    public func prepare(_ sql: String) throws -> Statement {
        return try queue.sync(flags: .barrier) { () -> Statement in
            var statement: RawStatement?
            let code = sqlite3_prepare_v2(connection, sql, -1, &statement, .none)

            if code == SQLITE_OK, let statement = statement {
                return .init(statement: statement, on: connection)
            } else {
                throw DatabaseError.exec(code: code)
            }
        }
    }
}
