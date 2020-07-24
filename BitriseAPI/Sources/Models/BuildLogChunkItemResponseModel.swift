//
//  BuildLogChunkItemResponseModel.swift
//  BitriseAPI
//
//  Created by Yu Tawata on 2019/07/01.
//

import Foundation

public struct BuildLogChunkItemResponseModel: Equatable, Codable {
    public var chunk: String
    public var position: Int

    public init(
        chunk: String,
        position: Int
    ) {
        self.chunk = chunk
        self.position = position
    }
}
