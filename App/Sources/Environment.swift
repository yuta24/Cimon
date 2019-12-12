//
//  Environment.swift
//  App
//
//  Created by Yu Tawata on 2019/05/05.
//

import Foundation
import Mocha
import Shared
import Domain
import Core

public class Environment {
    let store: StoreProtocol
    let networks: [CI: NetworkServiceProtocol]
    let reporter: ReporterProtocol

    public init(store: StoreProtocol, networks: [CI: NetworkServiceProtocol], reporter: ReporterProtocol) {
        self.store = store
        self.networks = networks
        self.reporter = reporter
    }
}
