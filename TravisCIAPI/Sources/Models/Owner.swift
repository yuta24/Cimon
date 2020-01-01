//
//  Owner.swift
//  TravisCIAPI
//
//  Created by Yu Tawata on 2019/08/11.
//

import Foundation

extension Minimal {
    // sourcery: public-initializer
    public struct Owner: Codable {
        enum CodingKeys: String, CodingKey {
            case id
            case login
        }

        public var id: Int
        public var login: String

        // sourcery:inline:Minimal.Owner.Init
        // swiftlint:disable line_length
        public init(id: Int, login: String) {
            self.id = id
            self.login = login

        }
        // swiftlint:enabled line_length
        // sourcery:end
    }
}

extension Standard {
    // sourcery: public-initializer
    public struct Owner: Codable {
        enum CodingKeys: String, CodingKey {
            case id = "id"
            case login = "login"
            case name = "name"
            case githubId = "github_id"
            case avatarUrl = "avatar_url"
            case education = "education"
//            case allowMigration = "allow_migration"
        }

        public var id: Int
        public var login: String
        public var name: String?
        public var githubId: Int?
        public var avatarUrl: String?
        public var education: Bool?
//        public var allowMigration: Any

        // sourcery:inline:Standard.Owner.Init
        // swiftlint:disable line_length
        public init(id: Int, login: String, name: String?, githubId: Int?, avatarUrl: String?, education: Bool?) {
            self.id = id
            self.login = login
            self.name = name
            self.githubId = githubId
            self.avatarUrl = avatarUrl
            self.education = education

        }
        // swiftlint:enabled line_length
        // sourcery:end
    }
}
