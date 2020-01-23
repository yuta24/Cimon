//
//  TravisCIRequest.swift
//  TravisCIAPI
//
//  Created by Yu Tawata on 2019/05/05.
//

import Foundation
import Mocha

public protocol TravisCIRequest: Request {
}

extension TravisCIRequest where Response: Decodable {
  public var headers: [String: String] {
    [
      "Travis-API-Version": "3"
    ]
  }
  public var queryPrameters: [String: Any?] { [:] }
  public var bodyParameters: [String: Any] { [:] }

  public func parse(_ data: Data) throws -> Response {
        return try JSONDecoder().decode(Response.self, from: data)
  }
}

public enum Endpoint {
}
