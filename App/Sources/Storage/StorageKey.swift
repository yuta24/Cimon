//
//  Storage.swift
//  App
//
//  Created by Yu Tawata on 2019/05/05.
//

import Foundation
import Shared
import Domain

public extension StorageKey {
    static var travisCIToken: StorageKey<TravisCIToken> {
        return StorageKey<TravisCIToken>(rawValue: "travis_ci:token")
    }
    static var circleCIToken: StorageKey<CircleCIToken> {
        return StorageKey<CircleCIToken>(rawValue: "circle_ci:token")
    }
    static var bitriseToken: StorageKey<BitriseToken> {
        return StorageKey<BitriseToken>(rawValue: "bitrise:token")
    }
}
