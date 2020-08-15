//
//  ColumnsBuilder.swift
//  Litey
//
//  Created by Yu Tawata on 2020/08/14.
//

import Foundation

public class ColumnsBuilder {
    public enum PrimaryKey {
        case `default`
        case autoincrement
    }

    fileprivate(set) var columns = [String]()

    public func column<V>(name: String, type: V.Type, primaryKey: PrimaryKey? = .none) where V: Value, V.Storage == Integer {
        column(name: name, type: type, primaryKey: primaryKey, notnull: true, unique: false, default: nil)
    }

    public func column<V>(name: String, type: V.Type, primaryKey: PrimaryKey? = .none) where V: Value, V.Storage == Text {
        column(name: name, type: type, primaryKey: primaryKey, notnull: false, unique: false, default: nil)
    }

    public func column<V>(name: String, type: V.Type, notNull: Bool = false, unique: Bool = false, default: V? = .none) where V: Value {
        column(name: name, type: type, primaryKey: .none, notnull: notNull, unique: unique, default: nil)
    }

    func column<V>(name: String, type: V.Type, primaryKey: PrimaryKey?, notnull isNotNull: Bool, unique isUnique: Bool, default: V?) where V: Value {
        var literals = [String]()
        literals.append(name)
        literals.append(V.Storage.typeName)
        switch primaryKey {
        case .default:
            literals.append("PRIMARY KEY")
        case .autoincrement:
            literals.append("PRIMARY KEY AUTOINCREMENT")
        case .none:
            break
        }
        if isNotNull {
            literals.append("NOT NULL")
        }
        if isUnique {
            literals.append("UNIQUE")
        }
        if let value = `default` {
            literals.append("DEFAULT \(value)")
        }

        columns.append(literals.joined(separator: " "))
    }
}

extension ColumnsBuilder {
    public func column<V>(_ column: Column<V>, primaryKey: PrimaryKey? = .none) where V: Value, V.Storage == Integer {
        self.column(name: column.name, type: V.self, primaryKey: primaryKey)
    }

    public func column<V>(_ column: Column<V>, primaryKey: PrimaryKey? = .none) where V: Value, V.Storage == Text {
        self.column(name: column.name, type: V.self, primaryKey: primaryKey)
    }

    public func column<V>(_ column: Column<V>, notNull: Bool = false, unique: Bool = false, default: V? = .none) where V: Value {
        self.column(name: column.name, type: V.self, notNull: notNull, unique: unique, default: `default`)
    }
}
