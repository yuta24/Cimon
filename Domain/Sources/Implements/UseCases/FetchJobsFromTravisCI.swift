//
//  FetchJobsFromTravisCI.swift
//  Domain
//
//  Created by Yu Tawata on 2019/08/11.
//

import Foundation
import APIKit
import ReactiveSwift
import Shared
import TravisCIAPI

public class FetchJobsFromTravisCI: FetchJobsFromTravisCIProtocol {
    let network: NetworkServiceProtocol

    public init(network: NetworkServiceProtocol) {
        self.network = network
    }

    public func run(buildId: Int) -> SignalProducer<Endpoint.JobsRequest.Response, SessionTaskError> {
        return network.response(Endpoint.JobsRequest(buildId: buildId))
    }
}
