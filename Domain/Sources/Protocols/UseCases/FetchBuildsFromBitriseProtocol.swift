//
//  FetchBuildsFromBitriseProtocol.swift
//  Domain
//
//  Created by tawata-yu on 2019/07/22.
//

import Foundation
import APIKit
import ReactiveSwift
import Shared
import BitriseAPI

public protocol FetchBuildsFromBitriseProtocol {
    func run(ownerSlug: String?, isOnHold: Bool?, status: Endpoint.Builds.Status?, next: String?, limit: Int) -> SignalProducer<BuildListAllResponseModel, SessionTaskError>
}
