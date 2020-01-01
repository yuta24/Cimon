//
//  FetchJobsFromTravisCI.swift
//  Domain
//
//  Created by Yu Tawata on 2019/08/11.
//

import Foundation
import Combine
import Mocha
import Shared
import TravisCIAPI

public class FetchJobsFromTravisCI: FetchJobsFromTravisCIProtocol {
  let client: Client

  public init(client: Client) {
    self.client = client
  }

  public func run(buildId: Int) -> AnyPublisher<Endpoint.JobsRequest.Response, Client.Failure> {
    client.publisher(for: Endpoint.JobsRequest(buildId: buildId))
  }
}
