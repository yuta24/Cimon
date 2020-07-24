//
//  Endpoint+Apps.swift
//  BitriseAPI
//
//  Created by Yu Tawata on 2020/07/11.
//

import Foundation
import Mocha

extension Endpoint {
    public struct AppsRequest: BitriseRequest {
        public typealias Response = AppListResponseModel

        public enum SortBy: String {
            case lastBuildAt = "last_build_at"
            case createdAt = "created_at"
        }

        public var path: String { "/apps" }
        public var method: HTTPMethod { .get }
        public var queryPrameters: [String: Any?] {
            var parameters = [String: Any]()

            if let sortBy = sortBy {
                parameters["sort_by"] = sortBy.rawValue
            }
            if let next = next {
                parameters["next"] = next
            }
            parameters["limit"] = limit

            return parameters
        }

        public let sortBy: SortBy?
        public let next: String?
        public let limit: Int

        public init(
            sortBy: SortBy?,
            next: String?,
            limit: Int = 50
        ) {
            self.sortBy = sortBy
            self.next = next
            self.limit = limit
        }
    }
}
