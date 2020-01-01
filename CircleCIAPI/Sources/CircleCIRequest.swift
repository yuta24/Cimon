//
//  CircleCIRequest.swift
//  CircleCIAPI
//
//  Created by Yu Tawata on 2019/05/07.
//

import Foundation
import Mocha

public protocol CircleCIRequest: Request {
}

extension CircleCIRequest where Response: Decodable {
  public var headers: [String: String] { [:] }
  public var queryPrameters: [String: Any?] { [:] }
  public var bodyParameters: [String: Any] { [:] }

  public func parse(_ data: Data) throws -> Response {
    return try JSONDecoder().decode(Response.self, from: data)
  }
}

public enum Endpoint {
}
