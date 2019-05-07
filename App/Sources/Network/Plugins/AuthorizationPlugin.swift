//
//  AuthorizationPlugin.swift
//  App
//
//  Created by Yu Tawata on 2019/05/06.
//

import Foundation

struct AuthorizationPlugin: NetworkServicePlugin {
    enum Kind {
        case basic(userName: String, password: String)
        case bearer(token: String)
        case customize(prefix: String?, token: String)
    }

    let kindProvider: () -> Kind?

    func prepare(urlRequest: URLRequest) -> URLRequest {
        var urlRequest = urlRequest

        if let kind = kindProvider() {
            switch kind {
            case .basic(let userName, let password):
                if let token = "\(userName):\(password)".data(using: .utf8)?.base64EncodedString() {
                    urlRequest.addValue("Basic \(token)", forHTTPHeaderField: "Authorization")
                }
            case .bearer(let token):
                urlRequest.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            case .customize(let prefix, let token):
                if let prefix = prefix {
                    urlRequest.addValue("\(prefix) \(token)", forHTTPHeaderField: "Authorization")
                } else {
                    urlRequest.addValue("\(token)", forHTTPHeaderField: "Authorization")
                }
            }
        }

        return urlRequest
    }

    func willSend(urlRequest: URLRequest) {
        // no operation.
    }

    func didReceive(object: Any, urlResponse: HTTPURLResponse) {
        // no operation.
    }
}
