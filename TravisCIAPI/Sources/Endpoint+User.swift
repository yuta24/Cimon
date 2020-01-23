//
//  Endpoint+User.swift
//  TravisCIAPI
//
//  Created by Yu Tawata on 2019/07/24.
//

import Foundation
import Mocha

extension Endpoint {
  public struct UserRequest: TravisCIRequest {
    public typealias Response = User

    public var path: String { "/user" }
    public var method: HTTPMethod { .get }

    public init() {
    }
  }
}
