//
//  StoreKey.swift
//  App
//
//  Created by Yu Tawata on 2019/05/05.
//

import Foundation
import Shared
import Domain

public extension PersistentKey {
    static var travisCIToken: PersistentKey<TravisCIToken> {
        return PersistentKey<TravisCIToken>(rawValue: "travis_ci:token")
    }
    static var circleCIToken: PersistentKey<CircleCIToken> {
        return PersistentKey<CircleCIToken>(rawValue: "circle_ci:token")
    }
    static var bitriseToken: PersistentKey<BitriseToken> {
        return PersistentKey<BitriseToken>(rawValue: "bitrise:token")
    }
}
