//
//  FetchBuildsFromBitrise.swift
//  Domain
//
//  Created by tawata-yu on 2019/07/22.
//

import Foundation
import Combine
import APIKit
import Mocha
import Shared
import BitriseAPI

public class FetchBuildsFromBitrise: FetchBuildsFromBitriseProtocol {
    let network: NetworkServiceProtocol

    public init(network: NetworkServiceProtocol) {
        self.network = network
    }

    public func run(ownerSlug: String?, isOnHold: Bool?, status: Endpoint.BuildsRequest.Status?, next: String?, limit: Int) -> AnyPublisher<BuildListAllResponseModel, SessionTaskError> {
        return network.response(Endpoint.BuildsRequest.init(ownerSlug: ownerSlug, isOnHold: isOnHold, status: status, next: next, limit: limit))
    }
}
