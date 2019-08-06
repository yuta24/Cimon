//
//  Endpoint+User.swift
//  TravisCIAPI
//
//  Created by Yu Tawata on 2019/07/24.
//

import Foundation
import APIKit

public extension Endpoint {
    struct UserRequest: TravisCIRequest {
        public typealias Response = User

        public var path: String {
            return "/user"
        }

        public var method: HTTPMethod {
            return .get
        }

        public init() {
        }
    }
}
