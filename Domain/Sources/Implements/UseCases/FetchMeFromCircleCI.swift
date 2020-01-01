//
//  FetchMeFromCircleCI.swift
//  Domain
//
//  Created by Yu Tawata on 2019/07/24.
//

import Combine
import Mocha
import CircleCIAPI

public class FetchMeFromCircleCI: FetchMeFromCircleCIProtocol {
  let client: Client

  public init(client: Client) {
    self.client = client
  }

  public func run() -> AnyPublisher<Endpoint.MeRequest.Response, Client.Failure> {
    client.publisher(for: Endpoint.MeRequest())
  }
}
