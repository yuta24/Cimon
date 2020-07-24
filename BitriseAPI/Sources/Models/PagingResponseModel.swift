//
//  PagingResponseModel.swift
//  BitriseAPI
//
//  Created by Yu Tawata on 2020/07/11.
//

import Foundation

public struct PagingResponseModel: Equatable, Codable {
    public var next: String?
    public var pageItemLimit: Int?
    public var totalItemCount: Int?

    public init(next: String?, pageItemLimit: Int?, totalItemCount: Int?) {
        self.next = next
        self.pageItemLimit = pageItemLimit
        self.totalItemCount = totalItemCount
    }
}
