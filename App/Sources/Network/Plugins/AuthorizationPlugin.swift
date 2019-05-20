//
//  AuthorizationPlugin.swift
//  App
//
//  Created by Yu Tawata on 2019/05/06.
//

import Foundation

public struct AuthorizationPlugin: NetworkServicePlugin {
    public enum Kind {
        case basic(userName: String, password: String)
        case bearer(token: String)
        case customize(prefix: String?, token: String)
    }

    let kindProvider: () -> Kind?

    public init(kindProvider: @escaping () -> Kind?) {
        self.kindProvider = kindProvider
    }

    public func prepare(urlRequest: URLRequest) -> URLRequest {
        var urlRequest = urlRequest

        switch kindProvider() {
        case .some(.basic(let userName, let password)):
            if let token = "\(userName):\(password)".data(using: .utf8)?.base64EncodedString() {
                urlRequest.addValue("Basic \(token)", forHTTPHeaderField: "Authorization")
            }
        case .some(.bearer(let token)):
            urlRequest.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        case .some(.customize(let prefix, let token)):
            if let prefix = prefix {
                urlRequest.addValue("\(prefix) \(token)", forHTTPHeaderField: "Authorization")
            } else {
                urlRequest.addValue("\(token)", forHTTPHeaderField: "Authorization")
            }
        case .none:
            break
        }

        return urlRequest
    }

    public func willSend(urlRequest: URLRequest) {
        // no operation.
    }

    public func didReceive(object: Any, urlResponse: HTTPURLResponse) {
        // no operation.
    }
}
