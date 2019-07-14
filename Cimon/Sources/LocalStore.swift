//
//  LocalStore.swift
//  Cimon
//
//  Created by Yu Tawata on 2019/05/14.
//

import Foundation
import Domain

class LocalStore: StoreProtocol {
    let userDefaults: UserDefaults

    public init(userDefaults: UserDefaults) {
        self.userDefaults = userDefaults
    }

    public func set<V>(_ value: V?, for key: StoreKey<V>) where V: Encodable {
        let encoder = JSONEncoder()
        let data = try? encoder.encode(value)
        userDefaults.set(data, forKey: key.rawValue)
    }

    public func value<V>(_ key: StoreKey<V>, _ completion: @escaping (V?) -> Void) where V: Decodable {
        let decoder = JSONDecoder()
        let data = userDefaults.data(forKey: key.rawValue)
        let value = data.flatMap({
            try? decoder.decode(V.self, from: $0)
        })
        completion(value)
    }

    func value<V>(_ key: StoreKey<V>) -> V? where V: Decodable {
        var value: V?

        let semaphore = DispatchSemaphore(value: 0)
        store.value(key) { (_value) in
            value = _value
            semaphore.signal()
        }
        semaphore.wait()

        return value
    }
}
