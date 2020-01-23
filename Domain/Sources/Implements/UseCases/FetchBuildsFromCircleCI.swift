//
//  FetchBuildsFromCircleCI.swift
//  Domain
//
//  Created by tawata-yu on 2019/07/22.
//

import Combine
import Mocha
import CircleCIAPI

public class FetchBuildsFromCircleCI: FetchBuildsFromCircleCIProtocol {
  let client: Client

  public init(client: Client) {
    self.client = client
  }

  public func run(limit: Int, offset: Int, shallow: Bool) -> AnyPublisher<[Build], Client.Failure> {
    client.publisher(for: Endpoint.RecentBuildsRequest(limit: limit, offset: offset, shallow: shallow))
  }
}
