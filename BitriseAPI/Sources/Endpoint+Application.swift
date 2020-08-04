//
//  Endpoint+Application.swift
//  BitriseAPI
//
//  Created by Yu Tawata on 2020/07/11.
//

import Foundation
import Mocha

extension Endpoint {
    public enum Application {
        public struct GetListOfApps: BitriseRequest {
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
                if let limit = limit {
                    parameters["limit"] = limit
                }

                return parameters
            }

            public var sortBy: SortBy?
            public var next: String?
            public var limit: Int?

            public init(
                sortBy: SortBy?,
                next: String?,
                limit: Int?
            ) {
                self.sortBy = sortBy
                self.next = next
                self.limit = limit
            }
        }
    }
}
