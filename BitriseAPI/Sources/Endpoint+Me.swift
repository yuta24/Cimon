//
//  Endpoint+Me.swift
//  BitriseAPI
//
//  Created by Yu Tawata on 2019/07/24.
//

import Foundation
import APIKit

public extension Endpoint {
    struct MeRequest: BitriseRequest {
        public typealias Response = UserProfileRespModel

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
