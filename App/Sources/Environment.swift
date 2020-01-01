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
    let clients: [CI: Client]
    let reporter: ReporterProtocol

    public init(store: StoreProtocol, clients: [CI: Client], reporter: ReporterProtocol) {
        self.store = store
        self.clients = clients
        self.reporter = reporter
    }
}
