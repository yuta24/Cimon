//
//  TravisCIDetailInteractor.swift
//  App
//
//  Created by Yu Tawata on 2019/08/11.
//

import Foundation
import APIKit
import ReactiveSwift
import TravisCIAPI
import Shared
import Domain
import Core

public protocol TravisCIDetailInteractorProtocol {
    func fetchDetail(buildId: Int) -> SignalProducer<(Standard.Build, [Standard.Job]), SessionTaskError>
}

public class TravisCIDetailInteractor: TravisCIDetailInteractorProtocol {
    private let fetchBuildTravisCI: FetchBuildFromTravisCIProtocol
    private let fetchJobsTravisCI: FetchJobsFromTravisCIProtocol

    public init(
        fetchBuildTravisCI: FetchBuildFromTravisCIProtocol,
        fetchJobsTravisCI: FetchJobsFromTravisCIProtocol) {
        self.fetchBuildTravisCI = fetchBuildTravisCI
        self.fetchJobsTravisCI = fetchJobsTravisCI
    }

    public func fetchDetail(buildId: Int) -> SignalProducer<(Standard.Build, [Standard.Job]), SessionTaskError> {
        return fetchBuildTravisCI.run(buildId: buildId)
            .combineLatest(with: fetchJobsTravisCI.run(buildId: buildId))
            .map({ ($0.0, $0.1.jobs) })
    }

    public func fetchBuild(buildId: Int) -> SignalProducer<Standard.Build, SessionTaskError> {
        return fetchBuildTravisCI.run(buildId: buildId)
    }

    public func fetchJobs(buildId: Int) -> SignalProducer<[Standard.Job], SessionTaskError> {
        return fetchJobsTravisCI.run(buildId: buildId)
            .map(\.jobs)
    }
}
