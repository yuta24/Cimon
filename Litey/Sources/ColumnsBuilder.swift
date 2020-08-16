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

    public func column<V>(name: String, type: V.Type, primaryKey: PrimaryKey? = .none) where V: Value, V: Binding, V.Storage == Integer {
        column(name: name, type: type, primaryKey: primaryKey, notnull: true, unique: false, default: nil)
    }

    public func column<V>(name: String, type: V.Type, primaryKey: PrimaryKey? = .none) where V: Value, V: Binding, V.Storage == Text {
        column(name: name, type: type, primaryKey: primaryKey, notnull: false, unique: false, default: nil)
    }

    public func column<V>(name: String, type: V.Type, notNull: Bool = false, unique: Bool = false, default: V? = .none) where V: Value, V: Binding {
        column(name: name, type: type, primaryKey: .none, notnull: notNull, unique: unique, default: nil)
    }

    func column<V>(name: String, type: V.Type, primaryKey: PrimaryKey?, notnull isNotNull: Bool, unique isUnique: Bool, default: V?) where V: Value, V: Binding {
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
