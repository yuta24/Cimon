//
//  FetchBuildFromTravisCI.swift
//  Domain
//
//  Created by Yu Tawata on 2019/08/11.
//

import Combine
import Mocha
import TravisCIAPI

public class FetchBuildFromTravisCI: FetchBuildFromTravisCIProtocol {
  let client: Client

  public init(client: Client) {
    self.client = client
  }

  public func run(buildId: Int) -> AnyPublisher<Endpoint.BuildRequest.Response, Client.Failure> {
    client.publisher(for: Endpoint.BuildRequest(buildId: buildId))
  }
}
