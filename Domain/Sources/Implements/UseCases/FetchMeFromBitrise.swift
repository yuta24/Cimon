//
//  FetchMeFromBitrise.swift
//  Domain
//
//  Created by Yu Tawata on 2019/07/22.
//

import Foundation
import Combine
import APIKit
import Mocha
import Shared
import BitriseAPI

public class FetchMeFromBitrise: FetchMeFromBitriseProtocol {
    let network: NetworkServiceProtocol

    public init(network: NetworkServiceProtocol) {
        self.network = network
    }

    public func run() -> AnyPublisher<Endpoint.MeRequest.Response, SessionTaskError> {
        return network.response(Endpoint.MeRequest())
    }
}
