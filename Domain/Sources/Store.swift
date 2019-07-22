//
//  Store.swift
//  Domain
//
//  Created by Yu Tawata on 2019/05/06.
//

import Foundation

public struct StoreKey<V>: RawRepresentable {
    public let rawValue: String

    public init(rawValue: String) {
        self.rawValue = rawValue
    }
}

public protocol StoreProtocol {
    func set<V>(_ value: V?, for key: StoreKey<V>) where V: Encodable
    func value<V>(_ key: StoreKey<V>, _ completion: @escaping (V?) -> Void) where V: Decodable
    func value<V>(_ key: StoreKey<V>) -> V? where V: Decodable
}
