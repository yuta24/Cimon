//
//  TravisCIDetailInteractor.swift
//  App
//
//  Created by Yu Tawata on 2019/08/11.
//

import Foundation
import Combine
import APIKit
import TravisCIAPI
import Shared
import Domain
import Core

public protocol TravisCIDetailInteractorProtocol {
  func fetchDetail(buildId: Int) -> AnyPublisher<(Standard.Build, [Standard.Job]), SessionTaskError>
}

public class TravisCIDetailInteractor: TravisCIDetailInteractorProtocol {
  private let fetchBuildTravisCI: FetchBuildFromTravisCIProtocol
  private let fetchJobsTravisCI: FetchJobsFromTravisCIProtocol

  public init(
      fetchBuildTravisCI: FetchBuildFromTravisCIProtocol,
      fetchJobsTravisCI: FetchJobsFromTravisCIProtocol
  ) {
    self.fetchBuildTravisCI = fetchBuildTravisCI
    self.fetchJobsTravisCI = fetchJobsTravisCI
  }

  public func fetchDetail(buildId: Int) -> AnyPublisher<(Standard.Build, [Standard.Job]), SessionTaskError> {
    fetchBuildTravisCI.run(buildId: buildId)
      .combineLatest(fetchJobsTravisCI.run(buildId: buildId))
      .map { ($0.0, $0.1.jobs) }
      .eraseToAnyPublisher()
  }

  public func fetchBuild(buildId: Int) -> AnyPublisher<Standard.Build, SessionTaskError> {
    fetchBuildTravisCI.run(buildId: buildId)
  }

  public func fetchJobs(buildId: Int) -> AnyPublisher<[Standard.Job], SessionTaskError> {
    fetchJobsTravisCI.run(buildId: buildId)
      .map(\.jobs)
      .eraseToAnyPublisher()
  }
}
