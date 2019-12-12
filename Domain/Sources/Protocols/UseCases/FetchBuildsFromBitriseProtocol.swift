//
//  FetchBuildsFromBitriseProtocol.swift
//  Domain
//
//  Created by tawata-yu on 2019/07/22.
//

import Foundation
import Combine
import APIKit

import Shared
import BitriseAPI

public protocol FetchBuildsFromBitriseProtocol {
    func run(ownerSlug: String?, isOnHold: Bool?, status: Endpoint.BuildsRequest.Status?, next: String?, limit: Int) -> AnyPublisher<BuildListAllResponseModel, SessionTaskError>
}
