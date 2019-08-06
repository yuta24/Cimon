//
//  Endpoint+Builds.swift
//  BitriseAPI
//
//  Created by Yu Tawata on 2019/05/06.
//

import Foundation
import APIKit

public extension Endpoint {
    struct BuildsRequest: BitriseRequest {
        public typealias Response = BuildListAllResponseModel

        public enum Status: Int {
            case notFinished = 0
            case successful
            case failed
            case abortedWithFailure
            case abortedWithSuccess
        }

        public var path: String {
            return "/builds"
        }

        public var method: HTTPMethod {
            return .get
        }

        public var queryParameters: [String: Any]? {
            var parameters = [String: Any]()

            if let ownerSlug = ownerSlug {
                parameters["owner_slug"] = ownerSlug
            }
            if let isOnHold = isOnHold {
                parameters["is_on_hold"] = isOnHold
            }
            if let status = status {
                parameters["status"] = status.rawValue
            }
            if let next = next {
                parameters["next"] = next
            }
            parameters["limit"] = limit

            return parameters
        }

        public var ownerSlug: String?
        public var isOnHold: Bool?
        public var status: Status?
        public var next: String?
        public var limit: Int

        public init(
            ownerSlug: String?,
            isOnHold: Bool?,
            status: Status?,
            next: String?,
            limit: Int = 50) {
            self.ownerSlug = ownerSlug
            self.isOnHold = isOnHold
            self.status = status
            self.next = next
            self.limit = limit
        }
    }
}
