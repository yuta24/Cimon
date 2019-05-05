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
    let storage: Storage

    public init(storage: Storage) {
        self.storage = storage
    }
}
