//
//  Repository.swift
//  TravisCIAPI
//
//  Created by Yu Tawata on 2019/05/05.
//

import Foundation

public struct Repository {
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case slug = "slug"
    }

    public let id: Int
    public var name: String
    public var slug: String

    public init(
        id: Int,
        name: String,
        slug: String) {
        self.id = id
        self.name = name
        self.slug = slug
    }
}
