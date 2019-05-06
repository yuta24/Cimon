//
//  Builds.swift
//  TravisCIAPI
//
//  Created by Yu Tawata on 2019/05/05.
//

import Foundation
import APIKit

public extension Endpoint {
    struct Builds: TravisCIRequest {
        public struct Response: Codable {
            enum CodingKeys: String, CodingKey {
                case pagination = "@pagination"
                case builds = "builds"
            }

            public var pagination: Pagination
            public var builds: [Build]
        }

        public var path: String {
            return "/builds"
        }

        public var method: HTTPMethod {
            return .get
        }

        public var queryParameters: [String : Any]? {
            return [
                "limit": limit,
                "offset": offset,
            ]
        }

        public var limit: Int
        public var offset: Int

        public init(limit: Int, offset: Int) {
            self.limit = limit
            self.offset = offset
        }
    }
}
