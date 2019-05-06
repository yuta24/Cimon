//
//  Storage.swift
//  Domain
//
//  Created by Yu Tawata on 2019/05/06.
//

import Foundation

public struct StorageKey<V>: RawRepresentable {
    public let rawValue: String

    public init(rawValue: String) {
        self.rawValue = rawValue
    }
}

public protocol StorageProtocol {
    func set<V>(_ value: V?, for key: StorageKey<V>) where V: Encodable
    func value<V>(_ key: StorageKey<V>, _ completion: @escaping (V?) -> Void) where V: Decodable
}
