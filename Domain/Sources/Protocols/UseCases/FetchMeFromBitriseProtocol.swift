//
//  FetchMeFromBitriseProtocol.swift
//  Domain
//
//  Created by Yu Tawata on 2019/07/22.
//

import Foundation
import APIKit
import ReactiveSwift
import Shared
import TravisCIAPI

public protocol FetchMeFromBitriseProtocol {
    func run(limit: Int, offset: Int) -> SignalProducer<Endpoint.Builds.Response, SessionTaskError>
}
