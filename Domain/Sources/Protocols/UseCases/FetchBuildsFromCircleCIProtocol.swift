//
//  FetchBuildsFromCircleCIProtocol.swift
//  Domain
//
//  Created by tawata-yu on 2019/07/22.
//

import Foundation
import Combine
import APIKit
import Shared
import CircleCIAPI

public protocol FetchBuildsFromCircleCIProtocol {
    func run(limit: Int, offset: Int, shallow: Bool) -> AnyPublisher<[Build], SessionTaskError>
}
