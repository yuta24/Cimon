//
//  BuildLogInfoResponseModel.swift
//  BitriseAPI
//
//  Created by Yu Tawata on 2019/07/01.
//

import Foundation

public struct BuildLogInfoResponseModel: Equatable, Codable {
    public var expiringRawLogUrl: String?
    public var generatedLogChunksNum: Int?
    public var isArchived: Bool?
    public var logChunks: [BuildLogChunkItemResponseModel]?
    public var timestamp: String?

    public init(
        expiringRawLogUrl: String?,
        generatedLogChunksNum: Int?,
        isArchived: Bool?,
        logChunks: [BuildLogChunkItemResponseModel]?,
        timestamp: String?
    ) {
        self.expiringRawLogUrl = expiringRawLogUrl
        self.generatedLogChunksNum = generatedLogChunksNum
        self.isArchived = isArchived
        self.logChunks = logChunks
        self.timestamp = timestamp
    }
}
