//
//  FetchBuildsFromTravisCIProtocol.swift
//  Domain
//
//  Created by tawata-yu on 2019/07/22.
//

import Combine
import Mocha
import TravisCIAPI

public protocol FetchBuildsFromTravisCIProtocol {
  func run(limit: Int, offset: Int) -> AnyPublisher<Endpoint.BuildsRequest.Response, Client.Failure>
}
