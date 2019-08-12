//
//  FetchBuildFromTravisCIProtocol.swift
//  Domain
//
//  Created by Yu Tawata on 2019/08/11.
//

import Foundation
import APIKit
import ReactiveSwift
import Shared
import TravisCIAPI

public protocol FetchBuildFromTravisCIProtocol {
    func run(buildId: Int) -> SignalProducer<Endpoint.BuildRequest.Response, SessionTaskError>
}
