//
//  BuildLogChunkItemResponseModel.swift
//  BitriseAPI
//
//  Created by Yu Tawata on 2019/07/01.
//

import Foundation

public struct BuildLogChunkItemResponseModel: Codable {
    enum CodingKeys: String, CodingKey {
        case chunk
        case position
    }

    public var chunk: String
    public var position: Int

    public init(
        chunk: String,
        position: Int) {
        self.chunk = chunk
        self.position = position
    }
}
