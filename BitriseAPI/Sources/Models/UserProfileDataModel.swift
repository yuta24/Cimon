//
//  UserProfileDataModel.swift
//  BitriseAPI
//
//  Created by Yu Tawata on 2019/07/22.
//

import Foundation

// sourcery: public-initializer
public struct UserProfileDataModel: Codable {
    enum CodingKeys: String, CodingKey {
        case avatarUrlString = "avatar_url"
        case email
        case slug
        case unconfirmedEmail = "unconfirmed_email"
        case username
    }

    public var avatarUrlString: String?
    public var email: String?
    public var slug: String?
    public var unconfirmedEmail: String?
    public var username: String?

    // sourcery:inline:UserProfileDataModel.Init
    // swiftlint:disable line_length
    public init(avatarUrlString: String?, email: String?, slug: String?, unconfirmedEmail: String?, username: String?) {
        self.avatarUrlString = avatarUrlString
        self.email = email
        self.slug = slug
        self.unconfirmedEmail = unconfirmedEmail
        self.username = username

    }
    // swiftlint:enabled line_length
    // sourcery:end
}
