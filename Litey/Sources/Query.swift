//
//  Query.swift
//  Litey
//
//  Created by Yu Tawata on 2020/08/11.
//

import Foundation
import SQLite3

public class ColumnsBuilder {
    public enum Constraint<V> where V: Value {
        case primaryKey
        case notNull
        case unique
        case `default`(value: V)

        var expression: String {
            switch self {
            case .primaryKey:
                return "PRIMARY KEY"
            case .notNull:
                return "NOT NULL"
            case .unique:
                return "UNIQUE"
            case .default(let value):
                return "DEFAULT \(value))"
            }
        }
    }

    private(set) var columns = [String]()

    public func column<V>(name: String, type: V.Type, constraints: [Constraint<V>] = []) where V: Value {
        var expressions = [String]()
        expressions.append(name)
        expressions.append(type.valueType.typeName)
        for constraint in constraints {
            expressions.append(constraint.expression)
        }

        columns.append(expressions.joined(separator: " "))
    }
}

public enum PragmaFunction {
    case tableInfo(tableName: String)

    var statement: String {
        switch self {
        case .tableInfo(let tableName):
            return "table_info(\(tableName))"
        }
    }
}

public class Query {
    let rawString: String

    init(rawString: String) {
        self.rawString = rawString
    }

    public static func create(ifNotExists: Bool = false, tableName: String, columns: (ColumnsBuilder) -> Void, withoutRowid: Bool = false) -> Query {
        let columnsBuilder = ColumnsBuilder()
        columns(columnsBuilder)

        var statements = [String]()
        statements.append("CREATE")
        statements.append("TABLE")
        if ifNotExists {
            statements.append("IF NOT EXISTS")
        }
        statements.append(tableName)
        statements.append("(")
        statements.append(columnsBuilder.columns.joined(separator: ", "))
        statements.append(")")
        if withoutRowid {
            statements.append("WITHOUT ROWID")
        }
        statements.append(";")

        return .init(rawString: statements.joined(separator: " "))
    }

    public static func drop(ifExists: Bool = true, tableName: String) -> Query {
        var statements = [String]()
        statements.append("DROP")
        statements.append("TABLE")
        if ifExists {
            statements.append("IF EXISTS")
        }
        statements.append(tableName)
        statements.append(";")

        return .init(rawString: statements.joined(separator: " "))
    }

    public static func pragma(_ function: PragmaFunction) -> Query {
        var statements = [String]()
        statements.append("PRAGMA")
        statements.append(function.statement)
        statements.append(";")

        return .init(rawString: statements.joined(separator: " "))
    }
}
