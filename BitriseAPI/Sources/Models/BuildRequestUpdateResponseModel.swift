//
//  BuildRequestUpdateResponseModel.swift
//  BitriseAPI
//
//  Created by Yu Tawata on 2020/07/12.
//

import Foundation

public struct BuildRequestUpdateResponseModel: Equatable, Codable {
    public struct BuildRequestResponseItemModel: Equatable, Codable {
        public var buildParams: String?
        public var createdAt: String?
        public var pullRequestUrl: String?
        public var slug: String?

        public init(
            buildParams: String?,
            createdAt: String?,
            pullRequestUrl: String?,
            slug: String?
        ) {
            self.buildParams = buildParams
            self.createdAt = createdAt
            self.pullRequestUrl = pullRequestUrl
            self.slug = slug
        }
    }

    public var data: BuildRequestResponseItemModel?

    public init(data: BuildRequestResponseItemModel?) {
        self.data = data
    }
}
