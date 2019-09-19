//
//  Environment.swift
//  App
//
//  Created by Yu Tawata on 2019/05/05.
//

import Foundation
import Shared
import Domain
import Core

public class Environment {
    let persistent: PersistentProtocol
    let networks: [CI: NetworkServiceProtocol]
    let reporter: ReporterProtocol

    public init(
        persistent: PersistentProtocol,
        networks: [CI: NetworkServiceProtocol],
        reporter: ReporterProtocol) {
        self.persistent = persistent
        self.networks = networks
        self.reporter = reporter
    }
}
