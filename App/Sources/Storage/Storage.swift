//
//  Storage.swift
//  App
//
//  Created by Yu Tawata on 2019/05/05.
//

import Foundation
import Shared
import Domain

public struct StorageKey<V>: RawRepresentable {
    public let rawValue: String

    public init(rawValue: String) {
        self.rawValue = rawValue
    }
}

extension StorageKey {
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

public class Storage {
    public enum Core {
        case userDefaults(UserDefaults)
    }

    private let core: Core

    public init(core: Core) {
        self.core = core
    }

    public func set<V>(_ value: V, for key: StorageKey<V>) {
        switch core {
        case .userDefaults(let userDefaults):
            userDefaults.set(value, forKey: key.rawValue)
        }
    }

    public func value<V>(_ key: StorageKey<V>, _ completion: @escaping (V?) -> Void) {
        switch core {
        case .userDefaults(let userDefaults):
            completion(userDefaults.value(forKey: key.rawValue) as? V)
        }
    }
}
