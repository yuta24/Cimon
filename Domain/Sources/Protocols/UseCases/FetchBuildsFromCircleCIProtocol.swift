//
//  FetchBuildsFromCircleCIProtocol.swift
//  Domain
//
//  Created by tawata-yu on 2019/07/22.
//

import Foundation
import APIKit
import ReactiveSwift
import Shared
import CircleCIAPI

public protocol FetchBuildsFromCircleCIProtocol {
    func run(limit: Int, offset: Int, shallow: Bool) -> SignalProducer<[Build], SessionTaskError>
}
