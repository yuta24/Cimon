//
//  FetchBuildsFromCircleCI.swift
//  Domain
//
//  Created by tawata-yu on 2019/07/22.
//

import Foundation
import APIKit
import ReactiveSwift
import Shared
import CircleCIAPI

public class FetchBuildsFromCircleCI: FetchBuildsFromCircleCIProtocol {
    let network: NetworkServiceProtocol

    public init(network: NetworkServiceProtocol) {
        self.network = network
    }

    public func run(limit: Int, offset: Int, shallow: Bool) -> SignalProducer<[Build], SessionTaskError> {
        return network.response(Endpoint.RecentBuilds(limit: limit, offset: offset, shallow: shallow))
    }
}
