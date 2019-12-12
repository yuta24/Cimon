//
//  FetchJobsFromTravisCIProtocol.swift
//  Domain
//
//  Created by Yu Tawata on 2019/08/11.
//

import Foundation
import Combine
import APIKit
import Shared
import TravisCIAPI

public protocol FetchJobsFromTravisCIProtocol {
    func run(buildId: Int) -> AnyPublisher<Endpoint.JobsRequest.Response, SessionTaskError>
}
