//
//  Endpoint+Build.swift
//  TravisCIAPI
//
//  Created by Yu Tawata on 2019/08/11.
//

import Foundation
import Mocha

extension Endpoint {
  public struct BuildRequest: TravisCIRequest {
    public typealias Response = Standard.Build

    public var path: String { "/build/\(buildId)" }
    public var method: HTTPMethod { .get }

    public let buildId: Int

    public init(buildId: Int) {
      self.buildId = buildId
    }
  }
}
