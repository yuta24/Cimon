//
//  User.swift
//  TravisCIAPI
//
//  Created by Yu Tawata on 2019/07/24.
//

import Foundation

// sourcery: public-initializer
public struct User: Codable {
    enum CodingKeys: String, CodingKey {
        case id
        case login
        case name
        case githubId = "github_id"
        case avatarUrlString = "avatar_url"
        case education
        case allowMigration = "allow_migration"
        case isSyncing = "is_syncing"
        case syncedAt = "synced_at"
    }

    public var id: Int
    public var login: String
    public var name: String
    public var githubId: Int
    public var avatarUrlString: String
    public var education: Bool
    public var allowMigration: Bool
    public var isSyncing: Bool
    public var syncedAt: String

    // sourcery:inline:User.Init
    // swiftlint:disable line_length
    public init(id: Int, login: String, name: String, githubId: Int, avatarUrlString: String, education: Bool, allowMigration: Bool, isSyncing: Bool, syncedAt: String) {
        self.id = id
        self.login = login
        self.name = name
        self.githubId = githubId
        self.avatarUrlString = avatarUrlString
        self.education = education
        self.allowMigration = allowMigration
        self.isSyncing = isSyncing
        self.syncedAt = syncedAt

    }
    // swiftlint:enabled line_length
    // sourcery:end
}
