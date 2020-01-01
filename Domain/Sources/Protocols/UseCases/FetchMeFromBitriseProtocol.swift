//
//  FetchMeFromBitriseProtocol.swift
//  Domain
//
//  Created by Yu Tawata on 2019/07/22.
//

import Combine
import Mocha
import BitriseAPI

public protocol FetchMeFromBitriseProtocol {
  func run() -> AnyPublisher<Endpoint.MeRequest.Response, Client.Failure>
}
