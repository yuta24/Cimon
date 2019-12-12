//
//  FetchBuildsFromCircleCI.swift
//  Domain
//
//  Created by tawata-yu on 2019/07/22.
//

import Foundation
import Combine
import APIKit
import Mocha
import Shared
import CircleCIAPI

public class FetchBuildsFromCircleCI: FetchBuildsFromCircleCIProtocol {
    let network: NetworkServiceProtocol

    public init(network: NetworkServiceProtocol) {
        self.network = network
    }

    public func run(limit: Int, offset: Int, shallow: Bool) -> AnyPublisher<[Build], SessionTaskError> {
        return network.response(Endpoint.RecentBuildsRequest(limit: limit, offset: offset, shallow: shallow))
    }
}
