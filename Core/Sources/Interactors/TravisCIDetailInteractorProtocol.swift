//
//  TravisCIDetailInteractorProtocol.swift
//  Core
//
//  Created by Yu Tawata on 2019/09/15.
//

import Foundation
import APIKit
import ReactiveSwift
import TravisCIAPI
import Shared
import Domain

public protocol TravisCIDetailInteractorProtocol {
    func fetchDetail(buildId: Int) -> SignalProducer<(Standard.Build, [Standard.Job]), SessionTaskError>
}
