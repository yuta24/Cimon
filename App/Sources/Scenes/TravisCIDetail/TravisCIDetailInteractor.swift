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

protocol TravisCIDetailInteractorProtocol {
    func fetchDetail(buildId: Int) -> SignalProducer<(Standard.Build, [Standard.Job]), SessionTaskError>
}

class TravisCIDetailInteractor: TravisCIDetailInteractorProtocol {
    private let fetchBuildTravisCI: FetchBuildFromTravisCIProtocol
    private let fetchJobsTravisCI: FetchJobsFromTravisCIProtocol

    init(
        fetchBuildTravisCI: FetchBuildFromTravisCIProtocol,
        fetchJobsTravisCI: FetchJobsFromTravisCIProtocol) {
        self.fetchBuildTravisCI = fetchBuildTravisCI
        self.fetchJobsTravisCI = fetchJobsTravisCI
    }

    func fetchDetail(buildId: Int) -> SignalProducer<(Standard.Build, [Standard.Job]), SessionTaskError> {
        return fetchBuildTravisCI.run(buildId: buildId)
            .combineLatest(with: fetchJobsTravisCI.run(buildId: buildId))
            .map({ ($0.0, $0.1.jobs) })
    }

    func fetchBuild(buildId: Int) -> SignalProducer<Standard.Build, SessionTaskError> {
        return fetchBuildTravisCI.run(buildId: buildId)
    }

    func fetchJobs(buildId: Int) -> SignalProducer<[Standard.Job], SessionTaskError> {
        return fetchJobsTravisCI.run(buildId: buildId)
            .map(\.jobs)
    }
}
