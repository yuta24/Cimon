//
//  FetchBuildsFromTravisCI.swift
//  Domain
//
//  Created by tawata-yu on 2019/07/22.
//

import Combine
import Mocha
import TravisCIAPI

public class FetchBuildsFromTravisCI: FetchBuildsFromTravisCIProtocol {
  let client: Client

  public init(client: Client) {
    self.client = client
  }

  public func run(limit: Int, offset: Int) -> AnyPublisher<Endpoint.BuildsRequest.Response, Client.Failure> {
    client.publisher(for: Endpoint.BuildsRequest(limit: limit, offset: offset))
  }
}
