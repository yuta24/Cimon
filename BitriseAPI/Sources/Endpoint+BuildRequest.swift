//
//  Endpoint+BuildRequest.swift
//  BitriseAPI
//
//  Created by Yu Tawata on 2020/07/12.
//

import Foundation
import Mocha

extension Endpoint {
    public struct BuildRequestRequest: BitriseRequest {
        public typealias Response = BuildRequestUpdateResponseModel

        public var path: String { "/apps/\(appSlug)/build-requests/\(buildRequestSlug)" }
        public var method: HTTPMethod { .patch }

        public var bodyParameters: [String: Any] {
            [
                "is_approved": isApproved
            ]
        }

        public var appSlug: String
        public var buildRequestSlug: String

        public var isApproved: Bool

        public init(
            appSlug: String,
            buildRequestSlug: String,
            isApproved: Bool
        ) {
            self.appSlug = appSlug
            self.buildRequestSlug = buildRequestSlug
            self.isApproved = isApproved
        }
    }
}
