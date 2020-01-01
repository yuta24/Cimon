//
//  FetchBuildFromTravisCIProtocol.swift
//  Domain
//
//  Created by Yu Tawata on 2019/08/11.
//

import Combine
import Mocha
import TravisCIAPI

public protocol FetchBuildFromTravisCIProtocol {
  func run(buildId: Int) -> AnyPublisher<Endpoint.BuildRequest.Response, Client.Failure>
}
