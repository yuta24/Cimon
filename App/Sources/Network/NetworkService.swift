//
//  NetworkService.swift
//  App
//
//  Created by Yu Tawata on 2019/05/05.
//

import Foundation
import APIKit
import ReactiveSwift

public protocol NetworkServiceProtocol {
    func response<R>(_ request: R) -> SignalProducer<R.Response, SessionTaskError> where R: Request, R.Response: Decodable
}

public class NetworkService: NetworkServiceProtocol {
    let session: Session
    var plugins: [NetworkServicePlugin]

    public init(session: Session, plugins: [NetworkServicePlugin] = []) {
        self.session = session
        self.plugins = plugins
    }

    public func response<R>(_ request: R) -> SignalProducer<R.Response, SessionTaskError> where R: Request, R.Response: Decodable {
        let wrap = NetworkServiceRequest(request, plugins: plugins)
        return SignalProducer<R.Response, SessionTaskError>.init({ (observer, lifetime) in
            let task = self.session.send(wrap, callbackQueue: .dispatchQueue(.global(qos: .background)), handler: { (result) in
                switch result {
                case .success(let response):
                    observer.send(value: response)
                case .failure(let failure):
                    observer.send(error: failure)
                }
            })

            lifetime.observeEnded {
                task?.cancel()
            }
        })
    }
}
