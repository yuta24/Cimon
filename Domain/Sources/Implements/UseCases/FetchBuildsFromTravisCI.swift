//
//  FetchBuildsFromTravisCI.swift
//  Domain
//
//  Created by tawata-yu on 2019/07/22.
//

import Foundation
import APIKit
import ReactiveSwift
import Shared
import TravisCIAPI

public class FetchBuildsFromTravisCI: FetchBuildsFromTravisCIProtocol {
    let network: NetworkServiceProtocol

    public init(network: NetworkServiceProtocol) {
        self.network = network
    }

    public func run(limit: Int, offset: Int) -> SignalProducer<Endpoint.Builds.Response, SessionTaskError> {
        return network.response(Endpoint.Builds(limit: limit, offset: offset))
    }
}
