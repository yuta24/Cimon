//
//  NetworkServiceProtocol.swift
//  Domain
//
//  Created by tawata-yu on 2019/07/22.
//

import Foundation
import APIKit
import ReactiveSwift

public protocol NetworkServiceProtocol: class {
    func response<R>(_ request: R) -> SignalProducer<R.Response, SessionTaskError> where R: Request, R.Response: Decodable
}
