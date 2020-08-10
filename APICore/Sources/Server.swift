//
//  Server.swift
//  APICore
//
//  Created by Yu Tawata on 2020/08/09.
//

import Foundation

public struct Server {
    public let baseURL: URL

    public init(baseURL: URL) {
        self.baseURL = baseURL
    }

    func requestBuild<R>(_ request: R) -> URLRequest where R: Request {
        RequestBuilder().build(request, with: baseURL)
    }
}
