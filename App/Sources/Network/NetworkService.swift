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
