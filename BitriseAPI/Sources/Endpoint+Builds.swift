//
//  Endpoint+Builds.swift
//  BitriseAPI
//
//  Created by Yu Tawata on 2019/05/06.
//

import Foundation
import Mocha

extension Endpoint {
    public struct BuildsRequest: BitriseRequest {
        public typealias Response = BuildListAllResponseModel

        public enum Status: Int {
            case notFinished = 0
            case successful
            case failed
            case abortedWithFailure
            case abortedWithSuccess
        }

        public var path: String { "/builds" }
        public var method: HTTPMethod { .get }
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

        public let ownerSlug: String?
        public let isOnHold: Bool?
        public let status: Status?
        public let next: String?
        public let limit: Int

        public init(
            ownerSlug: String?,
            isOnHold: Bool?,
            status: Status?,
            next: String?,
            limit: Int = 50
        ) {
            self.ownerSlug = ownerSlug
            self.isOnHold = isOnHold
            self.status = status
            self.next = next
            self.limit = limit
        }
    }

    public struct BuildsAbortRequest: BitriseRequest {
        public typealias Response = BuildAbortResponseModel

        public struct BuildAbortParams: Codable {
            public var abortReason: String
            public var abortWithSuccess: Bool
            public var skipNotifications: Bool
        }

        public var path: String { "/builds" }
        public var method: HTTPMethod { .get }
        public var bodyParameters: [String: Any] {
            return [
                "build-abort-params": [
                    "abort_reason": abortParams.abortReason,
                    "abort_with_success": abortParams.abortWithSuccess,
                    "skip_notifications": abortParams.skipNotifications
                ]
            ]
        }

        public let appSlug: String
        public let buildSlug: String
        public let abortParams: BuildAbortParams

        public init(
            appSlug: String,
            buildSlug: String,
            abortParams: BuildAbortParams
        ) {
            self.appSlug = appSlug
            self.buildSlug = buildSlug
            self.abortParams = abortParams
        }
    }
}
