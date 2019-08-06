//
//  Me.swift
//  CircleCIAPI
//
//  Created by Yu Tawata on 2019/07/24.
//

import Foundation

// sourcery: public-initializer
public struct Me: Codable {
    enum CodingKeys: String, CodingKey {
        case login
        case avatarUrlString = "avatar_url"
        case name
        case githubId = "github_id"
        case bitbucket
    }

    public var login: String
    public var avatarUrlString: String
    public var name: String
    public var githubId: Int?
    public var bitbucket: Int?

    // sourcery:inline:Me.Init
    // swiftlint:disable line_length
    public init(login: String, avatarUrlString: String, name: String, githubId: Int?, bitbucket: Int?) {
        self.login = login
        self.avatarUrlString = avatarUrlString
        self.name = name
        self.githubId = githubId
        self.bitbucket = bitbucket

    }
    // swiftlint:enabled line_length
    // sourcery:end
}
