//
//  FetchMeFromCircleCIProtocol.swift
//  Domain
//
//  Created by Yu Tawata on 2019/07/24.
//

import Combine
import Mocha
import CircleCIAPI

public protocol FetchMeFromCircleCIProtocol {
  func run() -> AnyPublisher<Endpoint.MeRequest.Response, Client.Failure>
}
