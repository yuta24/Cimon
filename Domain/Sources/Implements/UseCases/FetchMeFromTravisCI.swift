//
//  FetchMeFromTravisCI.swift
//  Domain
//
//  Created by Yu Tawata on 2019/07/24.
//

import Foundation
import APIKit
import ReactiveSwift
import Shared
import TravisCIAPI

public class FetchMeFromTravisCI: FetchMeFromTravisCIProtocol {
    let network: NetworkServiceProtocol

    public init(network: NetworkServiceProtocol) {
        self.network = network
    }

    public func run() -> SignalProducer<Endpoint.UserRequest.Response, SessionTaskError> {
        return network.response(Endpoint.UserRequest())
    }
}