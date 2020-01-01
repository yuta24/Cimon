//
//  Endpoint+RecentBuilds.swift
//  CircleCIAPI
//
//  Created by Yu Tawata on 2019/05/07.
//

import Foundation
import Mocha

extension Endpoint {
  public struct RecentBuildsRequest: CircleCIRequest {
    public typealias Response = [Build]

    public var path: String { "/recent-builds" }
    public var method: HTTPMethod { .get }

    public var queryPrameters: [String: Any?] {
      [
        "limit": limit,
        "offset": offset,
        "shallow": shallow
      ]
    }

    public let limit: Int
    public let offset: Int
    public let shallow: Bool

    public init(
      limit: Int = 30,
      offset: Int = 0,
      shallow: Bool = true
    ) {
      self.limit = limit
      self.offset = offset
      self.shallow = shallow
    }
  }
}
