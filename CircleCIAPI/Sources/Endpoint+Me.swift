//
//  Endpoint+Me.swift
//  CircleCIAPI
//
//  Created by Yu Tawata on 2019/07/24.
//

import Foundation
import Mocha

extension Endpoint {
  public struct MeRequest: CircleCIRequest {
    public typealias Response = Me

    public var path: String { "/me" }
    public var method: HTTPMethod { .get }

    public init() {
    }
 }
}
