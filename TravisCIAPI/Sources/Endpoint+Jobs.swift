//
//  Endpoint+Jobs.swift
//  TravisCIAPI
//
//  Created by Yu Tawata on 2019/08/11.
//

import Foundation
import Mocha

extension Endpoint {
  public struct JobsRequest: TravisCIRequest {
    public typealias Response = Standard.Jobs

    public var path: String { "/build/\(buildId)/jobs" }
    public var method: HTTPMethod { .get }

    public let buildId: Int

    public init(buildId: Int) {
      self.buildId = buildId
    }
  }
}
