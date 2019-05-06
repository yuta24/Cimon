//
//  AppResponseItemModel.swift
//  BitriseAPI
//
//  Created by Yu Tawata on 2019/05/06.
//

import Foundation

public struct AppResponseItemModel: Codable {
    enum CodingKeys: String, CodingKey {
        case avatarUrlString = "avatar_url"
        case isDisabled = "is_disabled"
        case isPublic = "is_public"
        case owner
        case projectType = "project_type"
        case provider
        case repoOwner = "repo_owner"
        case repoSlug = "repo_slug"
        case repoUrlString = "repo_url"
        case slug
        case status
        case title
    }

    public var avatarUrlString: String?
    public var isDisabled: Bool?
    public var isPublic: Bool?
    public var owner: OwnerAccountResponseModel?
    public var projectType: String?
    public var provider: String?
    public var repoOwner: String?
    public var repoSlug: String?
    public var repoUrlString: String?
    public var slug: String?
    public var status: Int?
    public var title: String?

    public init(
        avatarUrlString: String?,
        isDisabled: Bool?,
        isPublic: Bool?,
        owner: OwnerAccountResponseModel?,
        projectType: String?,
        provider: String?,
        repoOwner: String?,
        repoSlug: String?,
        repoUrlString: String?,
        slug: String?,
        status: Int?,
        title: String?) {
        self.avatarUrlString = avatarUrlString
        self.isDisabled = isDisabled
        self.isPublic = isPublic
        self.owner = owner
        self.projectType = projectType
        self.provider = provider
        self.repoOwner = repoOwner
        self.repoSlug = repoSlug
        self.repoUrlString = repoUrlString
        self.slug = slug
        self.status = status
        self.title = title
    }
}
