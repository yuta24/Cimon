//
//  BitriseTokenStore.swift
//  Core
//
//  Created by Yu Tawata on 2020/07/08.
//

import Foundation
import Domain

public protocol BitriseTokenStore: AnyObject {
    func save(_ token: BitriseToken)
    func load() -> BitriseToken?
    func remove()
}
