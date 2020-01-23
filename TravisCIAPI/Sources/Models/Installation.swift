//
//  Installation.swift
//  TravisCIAPI
//
//  Created by Yu Tawata on 2019/08/11.
//

import Foundation

// sourcery: public-initializer
public struct Installation: Codable {
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case githubId = "github_id"
//        case owner = "owner"
    }

    public var id: Int
    public var githubId: Int
//    public var owner: Owner?

    // sourcery:inline:Installation.Init
    // swiftlint:disable line_length
    public init(id: Int, githubId: Int) {
        self.id = id
        self.githubId = githubId

    }
    // swiftlint:enabled line_length
    // sourcery:end
}
