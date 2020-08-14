//
//  Database+Query.swift
//  Litey
//
//  Created by Yu Tawata on 2020/08/12.
//

import Foundation

extension ColumnsBuilder {
    public func column<D>(_ column: Column<D>, constraints: [Constraint<D>] = []) {
        self.column(name: column.name, type: D.self, constraints: constraints)
    }
}

extension Database {
    public func prepare(_ query: Query) throws -> Statement {
        try prepare(query.rawString)
    }
}
