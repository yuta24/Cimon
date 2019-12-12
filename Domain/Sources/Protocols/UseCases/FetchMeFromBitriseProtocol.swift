//
//  FetchMeFromBitriseProtocol.swift
//  Domain
//
//  Created by Yu Tawata on 2019/07/22.
//

import Foundation
import Combine
import APIKit
import Shared
import BitriseAPI

public protocol FetchMeFromBitriseProtocol {
    func run() -> AnyPublisher<Endpoint.MeRequest.Response, SessionTaskError>
}
