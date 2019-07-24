//
//  Endpoint+Me.swift
//  CircleCIAPI
//
//  Created by Yu Tawata on 2019/07/24.
//

import Foundation
import APIKit

public extension Endpoint {
    struct MeRequest: CircleCIRequest {
        public typealias Response = Me

        public var path: String {
            return "/me"
        }

        public var method: HTTPMethod {
            return .get
        }

        public init() {
        }
    }
}
