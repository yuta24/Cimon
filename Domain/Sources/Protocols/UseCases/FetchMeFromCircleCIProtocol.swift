//
//  FetchMeFromCircleCIProtocol.swift
//  Domain
//
//  Created by Yu Tawata on 2019/07/24.
//

import Foundation
import APIKit
import ReactiveSwift
import Shared
import CircleCIAPI

public protocol FetchMeFromCircleCIProtocol {
    func run() -> SignalProducer<Endpoint.MeRequest.Response, SessionTaskError>
}
