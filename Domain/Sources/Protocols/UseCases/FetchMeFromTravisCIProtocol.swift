//
//  FetchMeFromTravisCIProtocol.swift
//  Domain
//
//  Created by Yu Tawata on 2019/07/24.
//

import Foundation
import APIKit
import ReactiveSwift
import Shared
import TravisCIAPI

public protocol FetchMeFromTravisCIProtocol {
    func run() -> SignalProducer<Endpoint.UserRequest.Response, SessionTaskError>
}
