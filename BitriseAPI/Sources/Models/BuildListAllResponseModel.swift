//
//  BuildListAllResponseModel.swift
//  BitriseAPI
//
//  Created by Yu Tawata on 2019/05/06.
//

import Foundation

public struct BuildListAllResponseModel: Equatable, Codable {
    public var data: [BuildListAllResponseItemModel]?
    public var paging: PagingResponseModel?

    public init(data: [BuildListAllResponseItemModel]?, paging: PagingResponseModel?) {
        self.data = data
        self.paging = paging

    }
}
