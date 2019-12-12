//
//  NetworkService.swift
//  Cimon
//
//  Created by Yu Tawata on 2019/06/19.
//

import Foundation
import Combine
import APIKit

//open class NetworkService: NetworkServiceProtocol {
//    let session: URLSession
//    var plugins: [NetworkServicePlugin]
//
//    public init(session: URLSession, plugins: [NetworkServicePlugin] = []) {
//        self.session = session
//        self.plugins = plugins
//    }
//
//  public func response<R>(_ request: R) -> AnyPublisher<R.Response, SessionTaskError> where R : Request {
//    RequestPublisher(session: session, request: request)
//      .eraseToAnyPublisher()
//  }
//}
