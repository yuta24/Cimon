//
//  FetchBuildsFromTravisCI.swift
//  Domain
//
//  Created by tawata-yu on 2019/07/22.
//

import Foundation
import Combine
import APIKit
import Mocha
import Shared
import TravisCIAPI

public class FetchBuildsFromTravisCI: FetchBuildsFromTravisCIProtocol {
    let network: NetworkServiceProtocol

    public init(network: NetworkServiceProtocol) {
        self.network = network
    }

    public func run(limit: Int, offset: Int) -> AnyPublisher<Endpoint.BuildsRequest.Response, SessionTaskError> {
        return network.response(Endpoint.BuildsRequest(limit: limit, offset: offset))
    }
}
