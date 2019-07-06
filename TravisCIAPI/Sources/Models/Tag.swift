//
//  Tag.swift
//  TravisCIAPI
//
//  Created by Yu Tawata on 2019/07/06.
//

import Foundation

public struct Tag: Codable {
    enum CodingKeys: String, CodingKey {
        case repositoryId = "repository_id"
        case name = "name"
        case lastBuildId = "last_build_id"
    }

    public var repositoryId: Int
    public var name: String
    public var lastBuildId: Int?

    public init(
        repositoryId: Int,
        name: String,
        lastBuildId: Int?) {
        self.repositoryId = repositoryId
        self.name = name
        self.lastBuildId = lastBuildId
    }
}
