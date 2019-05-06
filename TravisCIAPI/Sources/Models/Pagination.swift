//
//  Pagination.swift
//  TravisCIAPI
//
//  Created by Yu Tawata on 2019/05/05.
//

import Foundation

public struct Pagination: Codable {
    enum CodingKeys: String, CodingKey {
        case limit = "limit"
        case offset = "offset"
        case count = "count"
        case isFirst = "is_first"
        case isLast = "is_last"
        case next = "next"
        case prev = "prev"
        case first = "first"
        case last = "last"
    }

    public struct Linking: Codable {
        enum CodingKeys: String, CodingKey {
            case href = "@href"
            case offset = "offset"
            case limit = "limit"
        }

        public var href: String
        public var offset: Int
        public var limit: Int

        public init(
            href: String,
            offset: Int,
            limit: Int) {
            self.href = href
            self.offset = offset
            self.limit = limit
        }
    }

    public var limit: Int
    public var offset: Int
    public var count: Int
    public var isFirst: Bool
    public var isLast: Bool
    public var next: Linking?
    public var prev: Linking?
    public var first: Linking
    public var last: Linking

    public init(
        limit: Int,
        offset: Int,
        count: Int,
        isFirst: Bool,
        isLast: Bool,
        next: Linking?,
        prev: Linking?,
        first: Linking,
        last: Linking) {
        self.limit = limit
        self.offset = offset
        self.count = count
        self.isFirst = isFirst
        self.isLast = isLast
        self.next = next
        self.prev = prev
        self.first = first
        self.last = last
    }
}
