//
//  Endpoint+Jobs.swift
//  TravisCIAPI
//
//  Created by Yu Tawata on 2019/08/11.
//

import Foundation
import APIKit

public extension Endpoint {
    struct JobsRequest: TravisCIRequest {
        public typealias Response = Standard.Jobs

        public var path: String {
            return "/build/\(buildId)/jobs"
        }

        public var method: HTTPMethod {
            return .get
        }

        public var buildId: Int

        public init(buildId: Int) {
            self.buildId = buildId
        }
    }
}
