//
//  FetchMeFromBitrise.swift
//  Domain
//
//  Created by Yu Tawata on 2019/07/22.
//

import Combine
import Mocha
import BitriseAPI

public class FetchMeFromBitrise: FetchMeFromBitriseProtocol {
  let client: Client

  public init(client: Client) {
    self.client = client
  }

  public func run() -> AnyPublisher<Endpoint.MeRequest.Response, Client.Failure> {
    client.publisher(for: Endpoint.MeRequest())
  }
}
