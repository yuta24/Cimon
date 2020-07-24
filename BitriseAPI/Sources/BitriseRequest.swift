//
//  BitriseRequest.swift
//  BitriseAPI
//
//  Created by Yu Tawata on 2019/05/06.
//

import Foundation
import Mocha

private let decoder: JSONDecoder = {
    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase
    return decoder
}()

public protocol BitriseRequest: Request {
}

extension BitriseRequest where Response: Decodable {
  public var headers: [String: String] { [:] }
  public var queryPrameters: [String: Any?] { [:] }
  public var bodyParameters: [String: Any] { [:] }

  public func parse(_ data: Data) throws -> Response {
        return try decoder.decode(Response.self, from: data)
  }
}

public enum Endpoint {
}
