//
//  TravisCIRequest.swift
//  TravisCIAPI
//
//  Created by Yu Tawata on 2019/05/05.
//

import Foundation
import APIKit

public protocol TravisCIRequest: APIKit.Request {
}

public struct DecodableDataParser: DataParser {
    public var contentType: String? {
        return "application/json"
    }

    public func parse(data: Data) throws -> Any {
        return data
    }

}

public extension TravisCIRequest where Response: Decodable {
    var baseURL: URL {
        return URL(string: "https://api.travis-ci.org")!
    }

    var headerFields: [String : String] {
        return [
            "Travis-API-Version": "3"
        ]
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
