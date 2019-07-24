//
//  Endpoint+RecentBuilds.swift
//  CircleCIAPI
//
//  Created by Yu Tawata on 2019/05/07.
//

import Foundation
import APIKit

public extension Endpoint {
    struct RecentBuildsRequest: CircleCIRequest {
        public typealias Response = [Build]

        public var path: String {
            return "/recent-builds"
        }

        public var method: HTTPMethod {
            return .get
        }

        public var queryParameters: [String: Any]? {
            return [
                "limit": limit,
                "offset": offset,
                "shallow": shallow]
        }

        public var limit: Int
        public var offset: Int
        public var shallow: Bool

        public init(
            limit: Int = 30,
            offset: Int = 0,
            shallow: Bool = true) {
            self.limit = limit
            self.offset = offset
            self.shallow = shallow
        }
    }
}
