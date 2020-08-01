//
//  ArtifactListResponseModel.swift
//  BitriseAPI
//
//  Created by Yu Tawata on 2020/07/31.
//

import Foundation

public struct ArtifactListResponseModel: Equatable, Codable {
    public var data: [ArtifactListElementResponseModel]?
    public var paging: PagingResponseModel?

    public init(
        data: [ArtifactListElementResponseModel]? = nil,
        paging: PagingResponseModel? = nil
    ) {
        self.data = data
        self.paging = paging
    }
}
