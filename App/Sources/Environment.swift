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
    public let store: StoreProtocol

    public init(store: StoreProtocol) {
        self.store = store
    }
}
