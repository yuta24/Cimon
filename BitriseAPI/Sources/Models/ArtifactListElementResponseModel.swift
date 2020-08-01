//
//  ArtifactListElementResponseModel.swift
//  BitriseAPI
//
//  Created by Yu Tawata on 2020/07/31.
//

import Foundation

public struct ArtifactListElementResponseModel: Equatable, Codable {
//    public var artifactMeta: String?
    public var artifactType: String?
    public var fileSizeBytes: Int?
    public var isPublicPageEnabled: Bool?
    public var slug: String?
    public var title: String?

    public init(
//        artifactMeta: String?,
        artifactType: String?,
        fileSizeBytes: Int?,
        isPublicPageEnabled: Bool?,
        slug: String?,
        title: String?
    ) {
//        self.artifactMeta = artifactMeta
        self.artifactType = artifactType
        self.fileSizeBytes = fileSizeBytes
        self.isPublicPageEnabled = isPublicPageEnabled
        self.slug = slug
        self.title = title
    }
}
