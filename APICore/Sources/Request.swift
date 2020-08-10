//
//  Request.swift
//  APICore
//
//  Created by Yu Tawata on 2020/08/09.
//

import Foundation

public protocol Request {
    associatedtype Response

    var method: Method { get }
    var path: String { get }
    var headers: [String: String] { get }
    var queryParameters: [String: Any] { get }
    var bodyParameters: [String: Any] { get }

    func parse(data: Data) throws -> Response
}
