//
//  User.swift
//  LiteyTests
//
//  Created by Yu Tawata on 2020/08/15.
//

import Foundation
@testable import Litey

struct User: Record {
    let id: Int64
    var name: String
    var email: String
    var country: String
    var bio: String?

    init(item: Item) throws {
        self.id = try item.get(0)
        self.name = try item.get(1)
        self.email = try item.get(2)
        self.country = try item.get(3)
        self.bio = try item.get(4)
    }

    static let pathAndColumns: [(PartialKeyPath<User>, String)] = [
        (\User.id, "id"),
        (\User.name, "name"),
        (\User.email, "email"),
        (\User.country, "country"),
        (\User.bio, "bio"),
    ]

    static func definition(_ builder: ColumnsBuilder) {
        builder.column(name: "id", type: Int64.self, primaryKey: .default)
        builder.column(name: "name", type: String.self, notNull: true)
        builder.column(name: "email", type: String.self, notNull: true)
        builder.column(name: "country", type: String.self, notNull: true)
        builder.column(name: "bio", type: String.self)
    }
}
