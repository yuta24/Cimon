//
//  Commit.swift
//  TravisCIAPI
//
//  Created by Yu Tawata on 2019/05/05.
//

import Foundation

public struct Commit: Codable {
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case sha = "sha"
        case ref = "ref"
        case message = "message"
        case compareUrlString = "compare_url"
        case committedAt = "committed_at"
    }

    public let id: Int
    public var sha: String
    public var ref: String
    public var message: String
    public var compareUrlString: String
    public var committedAt: String?

    public init(
        id: Int,
        sha: String,
        ref: String,
        message: String,
        compareUrlString: String,
        committedAt: String?) {
        self.id = id
        self.sha = sha
        self.ref = ref
        self.message = message
        self.compareUrlString = compareUrlString
        self.committedAt = committedAt
    }
}
