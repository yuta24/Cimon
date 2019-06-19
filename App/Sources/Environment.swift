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
    let reporter: ReporterProtocol

    init(store: StoreProtocol, reporter: ReporterProtocol) {
        self.store = store
        self.reporter = reporter
    }
}
