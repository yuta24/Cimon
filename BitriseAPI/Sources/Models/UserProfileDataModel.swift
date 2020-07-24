//
//  UserProfileDataModel.swift
//  BitriseAPI
//
//  Created by Yu Tawata on 2019/07/22.
//

import Foundation

public struct UserProfileDataModel: Equatable, Codable {
    public var avatarUrl: String?
    public var email: String?
    public var slug: String?
    public var unconfirmedEmail: String?
    public var username: String?

    public init(avatarUrl: String?, email: String?, slug: String?, unconfirmedEmail: String?, username: String?) {
        self.avatarUrl = avatarUrl
        self.email = email
        self.slug = slug
        self.unconfirmedEmail = unconfirmedEmail
        self.username = username
    }
}
