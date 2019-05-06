//
//  AuthorizationPlugin.swift
//  App
//
//  Created by Yu Tawata on 2019/05/06.
//

import Foundation

struct AuthorizationPlugin: NetworkServicePlugin {
    enum Kind {
        case bearer
        case customize(String)
        case none
    }

    let kind: Kind
    let tokenProvider: () -> String?

    func prepare(urlRequest: URLRequest) -> URLRequest {
        var urlRequest = urlRequest

        if let token = tokenProvider() {
            let authorization: String = {
                switch kind {
                case .bearer:
                    return "bearer \(token)"
                case .customize(let prefix):
                    return "\(prefix) \(token)"
                case .none:
                    return "\(token)"
                }
            }()
            urlRequest.addValue("\(authorization)", forHTTPHeaderField: "Authorization")
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
