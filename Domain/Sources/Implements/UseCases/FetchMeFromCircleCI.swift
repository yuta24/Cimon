//
//  FetchMeFromCircleCI.swift
//  Domain
//
//  Created by Yu Tawata on 2019/07/24.
//

import Foundation
import Combine
import APIKit
import Mocha
import Shared
import CircleCIAPI

public class FetchMeFromCircleCI: FetchMeFromCircleCIProtocol {
    let network: NetworkServiceProtocol

    public init(network: NetworkServiceProtocol) {
        self.network = network
    }

    public func run() -> AnyPublisher<Endpoint.MeRequest.Response, SessionTaskError> {
        return network.response(Endpoint.MeRequest())
    }
}
