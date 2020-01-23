//
//  Endpoint+Me.swift
//  BitriseAPI
//
//  Created by Yu Tawata on 2019/07/24.
//

import Foundation
import Mocha

extension Endpoint {
  public struct MeRequest: BitriseRequest {
    public typealias Response = UserProfileRespModel

    public var path: String { "/me" }
    public var method: HTTPMethod { .get }

    public init() {
    }
  }
}
