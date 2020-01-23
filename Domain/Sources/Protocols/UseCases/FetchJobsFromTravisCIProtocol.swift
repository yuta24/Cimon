//
//  FetchJobsFromTravisCIProtocol.swift
//  Domain
//
//  Created by Yu Tawata on 2019/08/11.
//

import Combine
import Mocha
import TravisCIAPI

public protocol FetchJobsFromTravisCIProtocol {
  func run(buildId: Int) -> AnyPublisher<Endpoint.JobsRequest.Response, Client.Failure>
}
