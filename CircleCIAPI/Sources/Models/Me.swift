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
    // sourcery:end
}
