//
//  AppResponseItemModel.swift
//  BitriseAPI
//
//  Created by Yu Tawata on 2019/05/06.
//

import Foundation

public struct AppResponseItemModel: Equatable, Codable {
    public var avatarUrl: String?
    public var isDisabled: Bool?
    public var isPublic: Bool?
    public var owner: OwnerAccountResponseModel?
    public var projectType: String?
    public var provider: String?
    public var repoOwner: String?
    public var repoSlug: String?
    public var repoUrl: String?
    public var slug: String?
    public var status: Int?
    public var title: String?

    public init(
        avatarUrl: String?,
        isDisabled: Bool?,
        isPublic: Bool?,
        owner: OwnerAccountResponseModel?,
        projectType: String?,
        provider: String?,
        repoOwner: String?,
        repoSlug: String?,
        repoUrl: String?,
        slug: String?,
        status: Int?,
        title: String?
    ) {
        self.avatarUrl = avatarUrl
        self.isDisabled = isDisabled
        self.isPublic = isPublic
        self.owner = owner
        self.projectType = projectType
        self.provider = provider
        self.repoOwner = repoOwner
        self.repoSlug = repoSlug
        self.repoUrl = repoUrl
        self.slug = slug
        self.status = status
        self.title = title
    }
}
