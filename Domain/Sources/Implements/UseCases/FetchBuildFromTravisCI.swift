//
//  FetchBuildFromTravisCI.swift
//  Domain
//
//  Created by Yu Tawata on 2019/08/11.
//

import Foundation
import APIKit
import ReactiveSwift
import Shared
import TravisCIAPI

public class FetchBuildFromTravisCI: FetchBuildFromTravisCIProtocol {
    let network: NetworkServiceProtocol

    public init(network: NetworkServiceProtocol) {
        self.network = network
    }

    public func run(buildId: Int) -> SignalProducer<Endpoint.BuildRequest.Response, SessionTaskError> {
        return network.response(Endpoint.BuildRequest(buildId: buildId))
    }
}
