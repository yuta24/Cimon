//
//  Query.swift
//  Litey
//
//  Created by Yu Tawata on 2020/08/11.
//

import Foundation
import SQLite3

public class Query {
    let rawString: String

    init(rawString: String) {
        self.rawString = rawString
    }
}

extension Query {
    public static func alter(tableName: String, renameTo newTableName: String) -> Query {
        var literals = [String]()
        literals.append("ALTER")
        literals.append("TABLE")
        literals.append(tableName)
        literals.append("RENAME TO")
        literals.append(newTableName)
        literals.append(";")

        return .init(rawString: literals.joined(separator: " "))
    }

    public static func alter(tableName: String, renameColumn columnName: String, to newColumnName: String) -> Query {
        var literals = [String]()
        literals.append("ALTER")
        literals.append("TABLE")
        literals.append(tableName)
        literals.append("RENAME COLUMN")
        literals.append(columnName)
        literals.append("TO")
        literals.append(newColumnName)
        literals.append(";")

        return .init(rawString: literals.joined(separator: " "))
    }
}

extension Query {
    public static func create(isTemporary: Bool = false, ifNotExists: Bool = false, tableName: String, columns: (ColumnsBuilder) -> Void, withoutRowid: Bool = false) -> Query {
        let columnsBuilder = ColumnsBuilder()
        columns(columnsBuilder)

        var literals = [String]()
        literals.append("CREATE")
        if isTemporary {
            literals.append("TEMPORARY")
        }
        literals.append("TABLE")
        if ifNotExists {
            literals.append("IF NOT EXISTS")
        }
        literals.append(tableName)
        literals.append("(")
        literals.append(columnsBuilder.columns.joined(separator: ", "))
        literals.append(")")
        if withoutRowid {
            literals.append("WITHOUT ROWID")
        }
        literals.append(";")

        return .init(rawString: literals.joined(separator: " "))
    }
}

extension Query {
    public static func drop(ifExists: Bool = true, tableName: String) -> Query {
        var literals = [String]()
        literals.append("DROP")
        literals.append("TABLE")
        if ifExists {
            literals.append("IF EXISTS")
        }
        literals.append(tableName)
        literals.append(";")

        return .init(rawString: literals.joined(separator: " "))
    }
}

extension Query {
    public static func insert() -> Query {
        return .init(rawString: "")
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

extension Query {
    public static func pragma(_ function: PragmaFunction) -> Query {
        var literals = [String]()
        literals.append("PRAGMA")
        literals.append(function.statement)
        literals.append(";")

        return .init(rawString: literals.joined(separator: " "))
    }
}

public enum SelecFetchtColumns {
    case all
    case columns([String])
}

public class SelectWhereBuilder {
    init() {
    }
}

extension Query {
    public static func select(distinct: Bool = false, columns: SelecFetchtColumns, from tableName: String, where whereBuilder: SelectWhereBuilder? = .none) -> Query {
        var literals = [String]()
        literals.append("SELECT")
        if distinct {
            literals.append("DISTINCT")
        }
        switch columns {
        case .all:
            literals.append("*")
        case .columns(let columnNames):
            literals.append(columnNames.joined(separator: ", "))
        }
        literals.append("FROM")
        literals.append(tableName)
        literals.append(";")

        return .init(rawString: literals.joined(separator: " "))
    }
}