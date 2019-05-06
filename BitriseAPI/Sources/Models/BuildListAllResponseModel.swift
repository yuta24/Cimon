//
//  BuildListAllResponseModel.swift
//  BitriseAPI
//
//  Created by Yu Tawata on 2019/05/06.
//

import Foundation

public struct BuildListAllResponseModel: Codable {
    enum CodingKeys: String, CodingKey {
        case data
        case paging
    }

    public var data: [BuildListAllResponseItemModel]?
    public var paging: Paging?

    public init(
        data: [BuildListAllResponseItemModel],
        paging: Paging) {
        self.data = data
        self.paging = paging
    }
}
