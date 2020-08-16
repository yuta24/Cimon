//
//  LocalStorage.swift
//  Cimon
//
//  Created by Yu Tawata on 2019/05/14.
//

import Foundation
import Domain

class LocalStorage: StorageProtocol {
    let userDefaults: UserDefaults

    public init(userDefaults: UserDefaults) {
        self.userDefaults = userDefaults
    }

    public func set<V>(_ value: V?, for key: StorageKey<V>) where V: Encodable {
        let encoder = JSONEncoder()
        let data = try? encoder.encode(value)
        userDefaults.set(data, forKey: key.rawValue)
    }

    func value<V>(_ key: StorageKey<V>) -> V? where V: Decodable {
        let decoder = JSONDecoder()
        let data = userDefaults.data(forKey: key.rawValue)
        let value = data.flatMap({
            try? decoder.decode(V.self, from: $0)
        })
        return value
    }
}
