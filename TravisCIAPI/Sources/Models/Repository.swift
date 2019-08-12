//
//  Repository.swift
//  TravisCIAPI
//
//  Created by Yu Tawata on 2019/05/05.
//

import Foundation

extension Minimal {
    // sourcery: public-initializer
    public struct Repository: Codable {
        enum CodingKeys: String, CodingKey {
            case id
            case name
            case slug
        }

        public let id: Int
        public var name: String
        public var slug: String

        // sourcery:inline:Minimal.Repository.Init
        // swiftlint:disable line_length
        public init(id: Int, name: String, slug: String) {
            self.id = id
            self.name = name
            self.slug = slug

        }
        // swiftlint:enabled line_length
        // sourcery:end
    }
}
