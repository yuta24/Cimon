//
//  BuildLogInfoResponseModel.swift
//  BitriseAPI
//
//  Created by Yu Tawata on 2019/07/01.
//

import Foundation

// sourcery: public-initializer
public struct BuildLogInfoResponseModel: Codable {
    enum CodingKeys: String, CodingKey {
        case expiringRawLogUrl = "expiring_raw_log_url"
        case generatedLogChunksNum = "generated_log_chunks_num"
        case isArchived = "is_archived"
        case logChunks = "log_chunks"
        case timestamp
    }

    public var expiringRawLogUrl: String?
    public var generatedLogChunksNum: Int?
    public var isArchived: Bool?
    public var logChunks: [BuildLogChunkItemResponseModel]?
    public var timestamp: String?

    // sourcery:inline:BuildLogInfoResponseModel.Init
    // swiftlint:disable line_length
    public init(expiringRawLogUrl: String?, generatedLogChunksNum: Int?, isArchived: Bool?, logChunks: [BuildLogChunkItemResponseModel]?, timestamp: String?) {
        self.expiringRawLogUrl = expiringRawLogUrl
        self.generatedLogChunksNum = generatedLogChunksNum
        self.isArchived = isArchived
        self.logChunks = logChunks
        self.timestamp = timestamp

    }
    // swiftlint:enabled line_length
    // sourcery:end
}
