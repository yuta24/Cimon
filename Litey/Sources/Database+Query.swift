//
//  Database+Query.swift
//  Litey
//
//  Created by Yu Tawata on 2020/08/12.
//

import Foundation

extension Database {
    public func execute(_ query: Query) throws {
        try execute(query.rawString)
    }

    public func prepare(_ query: Query) throws -> Statement {
        try prepare(query.rawString)
    }
}
