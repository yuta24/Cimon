//
//  FetchMeFromTravisCI.swift
//  Domain
//
//  Created by Yu Tawata on 2019/07/24.
//

import Combine
import Mocha
import TravisCIAPI

public class FetchMeFromTravisCI: FetchMeFromTravisCIProtocol {
  let client: Client

  public init(client: Client) {
    self.client = client
  }

  public func run() -> AnyPublisher<Endpoint.UserRequest.Response, Client.Failure> {
    client.publisher(for: Endpoint.UserRequest())
  }
}
