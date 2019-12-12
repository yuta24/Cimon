//
//  FetchBuildFromTravisCIProtocol.swift
//  Domain
//
//  Created by Yu Tawata on 2019/08/11.
//

import Foundation
import Combine
import APIKit
import Shared
import TravisCIAPI

public protocol FetchBuildFromTravisCIProtocol {
    func run(buildId: Int) -> AnyPublisher<Endpoint.BuildRequest.Response, SessionTaskError>
}
