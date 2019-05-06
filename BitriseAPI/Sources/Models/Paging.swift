//
//  Paging.swift
//  BitriseAPI
//
//  Created by Yu Tawata on 2019/05/06.
//

import Foundation

public struct Paging: Codable {
    enum CodingKeys: String, CodingKey {
        case next = "next"
        case pageItemLimit = "page_item_limit"
        case totalItemCount = "total_item_count"
    }

    public var next: String?
    public var pageItemLimit: Int?
    public var totalItemCount: Int?

    public init(
        next: String?,
        pageItemLimit: Int?,
        totalItemCount: Int?) {
        self.next = next
        self.pageItemLimit = pageItemLimit
        self.totalItemCount = totalItemCount
    }
}
