//
//  NetworkService.swift
//  App
//
//  Created by Yu Tawata on 2019/05/05.
//

import Foundation
import APIKit
import Promises

public protocol NetworkServiceProtocol {
    func response<R>(_ request: R) -> Promise<R.Response> where R: Request, R.Response: Decodable
}

public class NetworkService: NetworkServiceProtocol {
    let session: Session
    var plugins: [NetworkServicePlugin]

    public init(session: Session, plugins: [NetworkServicePlugin] = []) {
        self.session = session
        self.plugins = plugins
    }

    public func response<R>(_ request: R) -> Promise<R.Response> where R: Request, R.Response: Decodable {
        let wrap = NetworkServiceRequest(request, plugins: plugins)
        return Promise({ (fulfill, reject) in
            self.session.send(
                wrap,
                callbackQueue: .dispatchQueue(.global(qos: .background)),
                handler: { (result) in
                    switch result {
                    case .success(let response):
                        fulfill(response)
                    case .failure(let failure):
                        reject(failure)
                    }
            })
        })
    }
}
