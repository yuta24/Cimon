//
//  Request.swift
//  Mocha
//
//  Created by tawata-yu on 2019/12/18.
//

import Foundation

public enum HTTPMethod: String {
  case get    = "GET"
  case put    = "PUT"
  case post   = "POST"
  case delete = "DELETE"
}

public protocol Request {
  associatedtype Response

  var path: String { get }
  var method: HTTPMethod { get }
  var headers: [String: String] { get }
  var queryParameters: [String: Any] { get }
  var bodyParameters: [String: Any] { get }
}

func buildRequest<R>(_ request: R, with baseURL: URL) -> URLRequest where R: Request {
  let url = baseURL.appendingPathComponent(request.path)

  var urlRequest = URLRequest(url: url)

  if !request.queryParameters.isEmpty {
    if var components = URLComponents(url: url, resolvingAgainstBaseURL: false) {
      var queryItems = [URLQueryItem]()
      request.queryParameters.forEach { (key, value) in
        queryItems.append(URLQueryItem(name: key, value: "\(value)"))
      }
      components.queryItems = queryItems
      urlRequest.url = components.url
    }
  }

  return urlRequest
}
