//
//  FetchBuildsFromBitrise.swift
//  Domain
//
//  Created by tawata-yu on 2019/07/22.
//

import Combine
import Mocha
import BitriseAPI

public class FetchBuildsFromBitrise: FetchBuildsFromBitriseProtocol {
  let client: Client

  public init(client: Client) {
    self.client = client
  }

  public func run(ownerSlug: String?, isOnHold: Bool?, status: Endpoint.BuildsRequest.Status?, next: String?, limit: Int) -> AnyPublisher<BuildListAllResponseModel, Client.Failure> {
    client.publisher(for: Endpoint.BuildsRequest(ownerSlug: ownerSlug, isOnHold: isOnHold, status: status, next: next, limit: limit))
  }
}
