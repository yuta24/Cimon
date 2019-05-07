//
//  CircleCIRequest.swift
//  CircleCIAPI
//
//  Created by Yu Tawata on 2019/05/07.
//

import Foundation
import APIKit

public protocol CircleCIRequest: APIKit.Request {
}

public struct DecodableDataParser: DataParser {
    public var contentType: String? {
        return "application/json"
    }

    public func parse(data: Data) throws -> Any {
        return data
    }

}

public extension CircleCIRequest where Response: Decodable {
    var baseURL: URL {
        return URL(string: "https://circleci.com/api/v1.1")!
    }

    var headerFields: [String: String] {
        return [:]
    }

    var dataParser: DataParser {
        return DecodableDataParser()
    }

    func response(from object: Any, urlResponse: HTTPURLResponse) throws -> Response {
        guard let data = object as? Data else {
            throw ResponseError.unexpectedObject(object)
        }
        return try JSONDecoder().decode(Response.self, from: data)
    }
}

public enum Endpoint {
}
