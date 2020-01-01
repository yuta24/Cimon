//
//  FetchBuildsFromBitriseProtocol.swift
//  Domain
//
//  Created by tawata-yu on 2019/07/22.
//

import Combine
import Mocha
import BitriseAPI

public protocol FetchBuildsFromBitriseProtocol {
  func run(ownerSlug: String?, isOnHold: Bool?, status: Endpoint.BuildsRequest.Status?, next: String?, limit: Int) -> AnyPublisher<BuildListAllResponseModel, Client.Failure>
}
