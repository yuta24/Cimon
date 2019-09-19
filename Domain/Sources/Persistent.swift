//
//  Persistent.swift
//  Domain
//
//  Created by Yu Tawata on 2019/05/06.
//

import Foundation

public struct PersistentKey<V>: RawRepresentable {
    public let rawValue: String

    public init(rawValue: String) {
        self.rawValue = rawValue
    }
}

public protocol PersistentProtocol: class {
    func set<V>(_ value: V?, for key: PersistentKey<V>) where V: Encodable
    func value<V>(_ key: PersistentKey<V>, _ completion: @escaping (V?) -> Void) where V: Decodable
    func value<V>(_ key: PersistentKey<V>) -> V? where V: Decodable
}
