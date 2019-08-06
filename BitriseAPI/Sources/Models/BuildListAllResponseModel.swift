//
//  BuildListAllResponseModel.swift
//  BitriseAPI
//
//  Created by Yu Tawata on 2019/05/06.
//

import Foundation

// sourcery: public-initializer
public struct BuildListAllResponseModel: Codable {
    enum CodingKeys: String, CodingKey {
        case data
        case paging
    }

    public var data: [BuildListAllResponseItemModel]?
    public var paging: Paging?

    // sourcery:inline:BuildListAllResponseModel.Init
    // swiftlint:disable line_length
    public init(data: [BuildListAllResponseItemModel]?, paging: Paging?) {
        self.data = data
        self.paging = paging

    }
    // swiftlint:enabled line_length
    // sourcery:end
}
