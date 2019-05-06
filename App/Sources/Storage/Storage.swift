//
//  Storage.swift
//  App
//
//  Created by Yu Tawata on 2019/05/05.
//

import Foundation
import Shared
import Domain

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

public class Storage: StorageProtocol {
    public enum Core {
        case userDefaults(UserDefaults)
    }

    private let core: Core

    public init(core: Core) {
        self.core = core
    }

    public func set<V>(_ value: V?, for key: StorageKey<V>) where V: Encodable {
        switch core {
        case .userDefaults(let userDefaults):
            let encoder = JSONEncoder()
            let data = try? encoder.encode(value)
            userDefaults.set(data, forKey: key.rawValue)
        }
    }

    public func value<V>(_ key: StorageKey<V>, _ completion: @escaping (V?) -> Void) where V: Decodable {
        switch core {
        case .userDefaults(let userDefaults):
            let decoder = JSONDecoder()
            let data = userDefaults.data(forKey: key.rawValue)
            let value = data.flatMap({
                try? decoder.decode(V.self, from: $0)
            })
            completion(value)
        }
    }
}
