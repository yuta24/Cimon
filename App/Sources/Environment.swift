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
    let store: StoreProtocol
    let networks: [CI: NetworkServiceProtocol]
    let sceneFactory: SceneFactoryProtocol
    let reporter: ReporterProtocol

    init(store: StoreProtocol, networks: [CI: NetworkServiceProtocol], sceneFactory: SceneFactoryProtocol, reporter: ReporterProtocol) {
        self.store = store
        self.networks = networks
        self.sceneFactory = sceneFactory
        self.reporter = reporter
    }
}
