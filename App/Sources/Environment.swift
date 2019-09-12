//
//  Environment.swift
//  App
//
//  Created by Yu Tawata on 2019/05/05.
//

import Foundation
import Shared
import Domain

public class Environment {
    let store: StoreProtocol
    let networks: [CI: NetworkServiceProtocol]
    let reporter: ReporterProtocol

    init(store: StoreProtocol, networks: [CI: NetworkServiceProtocol], reporter: ReporterProtocol) {
        self.store = store
        self.networks = networks
        self.reporter = reporter
    }
}
