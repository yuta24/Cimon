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
import BitriseAPI

public protocol FetchMeFromBitriseProtocol {
    func run() -> SignalProducer<Endpoint.MeRequest.Response, SessionTaskError>
}
