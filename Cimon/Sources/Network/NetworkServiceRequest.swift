//
//  NetworkServiceRequest.swift
//  App
//
//  Created by Yu Tawata on 2019/05/06.
//

import Foundation
import APIKit

struct NetworkServiceRequest<R>: APIKit.Request where R: APIKit.Request, R.Response: Decodable {
    typealias Response = R.Response

    var baseURL: URL {
        return request.baseURL
    }

    var method: HTTPMethod {
        return request.method
    }

    var path: String {
        return request.path
    }

    var parameters: Any? {
        return request.parameters
    }

    var queryParameters: [String: Any]? {
        return request.queryParameters
    }

    var bodyParameters: BodyParameters? {
        return request.bodyParameters
    }

    var headerFields: [String: String] {
        return request.headerFields
    }

    var dataParser: DataParser {
        return request.dataParser
    }

    private let request: R
    private let plugins: [NetworkServicePlugin]

    init(_ request: R, plugins: [NetworkServicePlugin]) {
        self.request = request
        self.plugins = plugins
    }

    func intercept(urlRequest: URLRequest) throws -> URLRequest {
        let urlRequest = plugins.reduce(urlRequest) { (urlRequest, plugin) in
            return plugin.prepare(urlRequest: urlRequest)
        }
        plugins.forEach { (plugin) in
            plugin.willSend(urlRequest: urlRequest)
        }
        return try request.intercept(urlRequest: urlRequest)
    }

    func intercept(object: Any, urlResponse: HTTPURLResponse) throws -> Any {
        return try request.intercept(object: object, urlResponse: urlResponse)
    }

    func response(from object: Any, urlResponse: HTTPURLResponse) throws -> R.Response {
        plugins.forEach { (plugin) in
            plugin.didReceive(object: object, urlResponse: urlResponse)
        }
        return try request.response(from: object, urlResponse: urlResponse)
    }
}
