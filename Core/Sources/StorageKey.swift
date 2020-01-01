//
//  StoreKey.swift
//  App
//
//  Created by Yu Tawata on 2019/05/05.
//

import Domain

public extension StoreKey {
    static var travisCIToken: StoreKey<TravisCIToken> {
        return StoreKey<TravisCIToken>(rawValue: "travis_ci:token")
    }
    static var circleCIToken: StoreKey<CircleCIToken> {
        return StoreKey<CircleCIToken>(rawValue: "circle_ci:token")
    }
    static var bitriseToken: StoreKey<BitriseToken> {
        return StoreKey<BitriseToken>(rawValue: "bitrise:token")
    }
}
