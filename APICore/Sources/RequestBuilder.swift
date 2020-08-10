//
//  RequestBuilder.swift
//  APICore
//
//  Created by Yu Tawata on 2020/08/09.
//

import Foundation

struct RequestBuilder {
    func build<R>(_ request: R, with baseURL: URL) -> URLRequest where R: Request {
        let url = baseURL.appendingPathComponent(request.path)

        var urlRequest = URLRequest(url: url)

        // Set method
        urlRequest.httpMethod = request.method.rawValue

        // Set headers
        request.headers.forEach { key, value in
            urlRequest.setValue(value, forHTTPHeaderField: key)
        }

        // Set query parameters
        if var components = URLComponents(url: url, resolvingAgainstBaseURL: false) {
            var queryItems = [URLQueryItem]()

            for (key, value) in request.queryParameters {
                if let array = value as? [Any] {
                    let _queryItems: [URLQueryItem] = array.compactMap {
                        return URLQueryItem(name: key, value: "\($0)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))
                    }
                    queryItems.append(contentsOf: _queryItems)
                } else {
                    queryItems.append(URLQueryItem(name: key, value: "\(value)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)))
                }
            }

            components.percentEncodedQueryItems = queryItems

            urlRequest.url = components.url
        }

        // Set body parameters
        if !request.bodyParameters.isEmpty {
            let data = try! JSONSerialization.data(withJSONObject: request.bodyParameters, options: .init())
            urlRequest.httpBody = data
        }
        return urlRequest
    }
}
