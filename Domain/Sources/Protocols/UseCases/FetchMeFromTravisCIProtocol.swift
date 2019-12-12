//
//  FetchMeFromTravisCIProtocol.swift
//  Domain
//
//  Created by Yu Tawata on 2019/07/24.
//

import Foundation
import Combine
import APIKit
import Shared
import TravisCIAPI

public protocol FetchMeFromTravisCIProtocol {
    func run() -> AnyPublisher<Endpoint.UserRequest.Response, SessionTaskError>
}
