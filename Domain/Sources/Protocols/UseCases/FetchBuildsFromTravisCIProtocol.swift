//
//  FetchBuildsFromTravisCIProtocol.swift
//  Domain
//
//  Created by tawata-yu on 2019/07/22.
//

import Foundation
import APIKit
import ReactiveSwift
import Shared
import TravisCIAPI

public protocol FetchBuildsFromTravisCIProtocol {
    func run(limit: Int, offset: Int) -> SignalProducer<Endpoint.Builds.Response, SessionTaskError>
}
