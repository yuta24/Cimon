//
//  Store.swift
//  Cimon
//
//  Created by Yu Tawata on 2019/05/14.
//

import Foundation
import Domain

public class Store: StoreProtocol {
    public enum Core {
        case userDefaults(UserDefaults)
    }

    private let core: Core

    public init(core: Core) {
        self.core = core
    }

    public func set<V>(_ value: V?, for key: StoreKey<V>) where V: Encodable {
        switch core {
        case .userDefaults(let userDefaults):
            let encoder = JSONEncoder()
            let data = try? encoder.encode(value)
            userDefaults.set(data, forKey: key.rawValue)
        }
    }

    public func value<V>(_ key: StoreKey<V>, _ completion: @escaping (V?) -> Void) where V: Decodable {
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
