//
//  FetchMeFromTravisCIProtocol.swift
//  Domain
//
//  Created by Yu Tawata on 2019/07/24.
//

import Combine
import Mocha
import TravisCIAPI

public protocol FetchMeFromTravisCIProtocol {
  func run() -> AnyPublisher<Endpoint.UserRequest.Response, Client.Failure>
}
