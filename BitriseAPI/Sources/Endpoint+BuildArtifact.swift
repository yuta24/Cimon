//
//  Endpoint+BuildArtifact.swift
//  BitriseAPI
//
//  Created by Yu Tawata on 2020/07/25.
//

import Foundation
import Mocha

extension Endpoint {
    public enum BuildArtifact {
        public struct GetListOfAllBuildArtifacts: BitriseRequest {
            public typealias Response = ArtifactListResponseModel

            public var path: String { "/apps/\(appSlug)/builds/\(buildSlug)/artifacts" }
            public var method: HTTPMethod { .get }
            public var queryPrameters: [String: Any?] {
                var parameters = [String: Any]()

                if let next = next {
                    parameters["next"] = next
                }
                if let limit = limit {
                    parameters["limit"] = limit
                }

                return parameters
            }

            public let appSlug: String
            public let buildSlug: String
            public let next: String?
            public let limit: Int?

            public init(
                appSlug: String,
                buildSlug: String,
                next: String?,
                limit: Int?
            ) {
                self.appSlug = appSlug
                self.buildSlug = buildSlug
                self.next = next
                self.limit = limit
            }
        }
    }
}
