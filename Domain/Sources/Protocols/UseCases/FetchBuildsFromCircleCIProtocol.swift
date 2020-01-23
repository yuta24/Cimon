//
//  FetchBuildsFromCircleCIProtocol.swift
//  Domain
//
//  Created by tawata-yu on 2019/07/22.
//

import Combine
import Mocha
import CircleCIAPI

public protocol FetchBuildsFromCircleCIProtocol {
  func run(limit: Int, offset: Int, shallow: Bool) -> AnyPublisher<[Build], Client.Failure>
}
