//
//  Endpoint+Builds.swift
//  TravisCIAPI
//
//  Created by Yu Tawata on 2019/05/05.
//

import Foundation
import Mocha

extension Endpoint {
  public struct BuildsRequest: TravisCIRequest {
    public typealias Response = Builds

    public var path: String { "/builds" }
    public var method: HTTPMethod { .get }
    public var queryPrameters: [String: Any?] {
      [
        "limit": limit,
        "offset": offset
      ]
    }

    public let limit: Int
    public let offset: Int

    public init(limit: Int, offset: Int) {
      self.limit = limit
      self.offset = offset
    }
  }
}
