//
//  Table.swift
//  Litey
//
//  Created by Yu Tawata on 2020/08/15.
//

import Foundation

public struct SchemaDefinition {
    let columnsBuilder: ColumnsBuilder

    init(_ builder: (ColumnsBuilder) -> Void) {
        let columnsBuilder = ColumnsBuilder()

        builder(columnsBuilder)

        self.columnsBuilder = columnsBuilder
    }
}

public protocol Record {
    init(item: Item) throws

    static var pathAndColumns: [(PartialKeyPath<Self>, String)] { get }
    static func definition(_ builder: ColumnsBuilder)
}

public class Table<V> where V: Record {
    public let name: String

    init(_ name: String = String(describing: V.self)) {
        self.name = name
    }
}

public class CreateBuilder<V> where V: Record {
    private let temp: Bool
    private let ifNotExists: Bool
    private let tableName: String

    init(temp: Bool, ifNotExists: Bool, tableName: String) {
        self.temp = temp
        self.ifNotExists = ifNotExists
        self.tableName = tableName
    }

    public func execute(on database: Database) throws {
        try database.execute(
            .create(isTemporary: temp, ifNotExists: ifNotExists, tableName: tableName, columns: { V.definition($0) }))
    }
}

public class DropBuilder<V> where V: Record {
    private let ifExists: Bool
    private let tableName: String

    init(ifExists: Bool, tableName: String) {
        self.ifExists = ifExists
        self.tableName = tableName
    }

    public func execute(on database: Database) throws {
        try database.execute(build())
    }

    func build() -> String {
        var statements = [String]()

        statements.append("DROP")
        statements.append("TABLE")
        if ifExists {
            statements.append("IF EXISTS")
        }
        statements.append(tableName)
        statements.append(";")

        return statements.joined(separator: " ")
    }
}

public class InsertBuilder<V> where V: Record {
    private let tableName: String

    private var columnNames = [String]()
    private var columnNameAndValues = [String: Value?]()

    init(tableName: String) {
        self.tableName = tableName
    }

    public func value<T>(_ value: T, for keyPath: KeyPath<V, T>) -> InsertBuilder<V> {
        let columnName = V.pathAndColumns.first(where: { keyPath == $0.0 })!.1
        columnNames.append(columnName)
        columnNameAndValues[columnName] = value as? Value
        return self
    }

    public func execute(on database: Database) throws {
        try database.execute(build())
    }

    func build() -> String {
        var statements = [String]()

        var values = [Any]()
        for columnName in columnNames {
            if let value = columnNameAndValues[columnName] {
                switch value {
                case .some(let _value):
                    if let string = _value as? String {
                        values.append(string.quote())
                    } else {
                        values.append(_value)
                    }
                case .none:
                    values.append("NULL")
                }
            }
        }

        statements.append("INSERT")
        statements.append("INTO")
        statements.append(tableName)
        statements.append("(")
        statements.append(columnNames.joined(separator: ", "))
        statements.append(")")
        statements.append("VALUES")
        statements.append("(")
        statements.append(values.map { "\($0)" }.joined(separator: ", "))
        statements.append(")")
        statements.append(";")

        return statements.joined(separator: " ")
    }
}

public class FetchBuilder<V> where V: Record {
    private let distinct: Bool
    private let tableName: String

    private var filter: String?
    private var orderby: String?
    private var limit: UInt?
    private var offset: UInt?

    init(distinct: Bool, tableName: String) {
        self.distinct = distinct
        self.tableName = tableName
    }

    @discardableResult
    public func filter(_ filterString: String) -> FetchBuilder {
        filter = filterString
        return self
    }

    @discardableResult
    public func orderby(_ orderbyString: String) -> FetchBuilder {
        orderby = orderbyString
        return self
    }

    @discardableResult
    public func limit(_ limit: UInt) -> FetchBuilder {
        self.limit = limit
        return self
    }

    @discardableResult
    public func limit(_ limit: UInt, offset: UInt) -> FetchBuilder {
        self.limit = limit
        self.offset = offset
        return self
    }

    public func execute(on database: Database) throws -> [V] {
        let statement = try database.prepare(build())
        return try statement.map(V.init(item:))
    }

    func build() -> String {
        var statements = [String]()

        statements.append("SELECT")
        if distinct {
            statements.append("DISTINCT")
        }
        statements.append("*")
        statements.append("FROM \(tableName)")
        if let filter = filter {
            statements.append("WHERE \(filter)")
        }
        if let orderby = orderby {
            statements.append("ORDER BY \(orderby)")
        }
        if let limit = limit {
            statements.append("LIMIT \(limit)")

            if let offset = offset {
                statements.append("OFFSET \(offset)")
            }
        }
        statements.append(";")

        return statements.joined(separator: " ")
    }
}

public class UpdateBuilder<V> where V: Record {
    private let tableName: String

    private var columnNames = [String]()
    private var columnNameAndValues = [String: Value?]()

    init(tableName: String) {
        self.tableName = tableName
    }

    public func setValue<T>(_ value: T, for keyPath: KeyPath<V, T>) -> UpdateBuilder<V>  {
        let columnName = V.pathAndColumns.first(where: { keyPath == $0.0 })!.1
        columnNames.append(columnName)
        columnNameAndValues[columnName] = value as? Value
        return self
    }

    public func execute(on database: Database) throws {
        try database.execute(build())
    }

    func build() -> String {
        var statements = [String]()

        var updateValues = [String]()
        for columnName in columnNames {
            if let value = columnNameAndValues[columnName] {
                switch value {
                case .some(let _value):
                    if let string = _value as? String {
                        updateValues.append("\(columnName) = \(string.quote())")
                    } else {
                        updateValues.append("\(columnName) = \(_value)")
                    }
                case .none:
                    updateValues.append("\(columnName) = NULL")
                }
            }
        }

        statements.append("UPDATE")
        statements.append(tableName)
        statements.append("SET")
        statements.append(updateValues.joined(separator: ", "))
        statements.append(";")

        return statements.joined(separator: " ")
    }
}

public class DeleteBuilder<V> where V: Record {
    private let tableName: String
    private var `where`: String?

    init(tableName: String) {
        self.tableName = tableName
    }

    public func `where`(_ whereString: String) -> DeleteBuilder<V> {
        `where` = whereString
        return self
    }

    public func execute(on database: Database) throws {
        try database.execute(build())
    }

    func build() -> String {
        var statements = [String]()

        statements.append("DELETE")
        statements.append("FROM \(tableName)")
        if let `where` = `where` {
            statements.append("WHERE \(`where`)")
        }
        statements.append(";")

        return statements.joined(separator: " ")
    }
}

extension Table {
    public func create(temp: Bool = false, ifNotExists: Bool = false) -> CreateBuilder<V> {
        .init(temp: temp, ifNotExists: ifNotExists, tableName: name)
    }

    public func drop(ifExists: Bool = false) -> DropBuilder<V> {
        .init(ifExists: ifExists, tableName: name)
    }

    public func insert() -> InsertBuilder<V> {
        .init(tableName: name)
    }

    public func fetch(distinct: Bool = false) -> FetchBuilder<V> {
        .init(distinct: distinct, tableName: name)
    }

    public func update() -> UpdateBuilder<V> {
        .init(tableName: name)
    }

    public func delete() -> DeleteBuilder<V> {
        .init(tableName: name)
    }
}
