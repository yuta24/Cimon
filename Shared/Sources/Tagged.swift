//
//  Tagged.swift
//  Shared
//
//  Created by Yu Tawata on 2019/05/11.
//

import Foundation

public struct Tagged<T, V> where V: Equatable {
    public var rawValue: V

    public init(rawValue: V) {
        self.rawValue = rawValue
    }
}

extension Tagged: RawRepresentable {
}

extension Tagged: Equatable {
    public static func == (lhs: Tagged<T, V>, rhs: Tagged<T, V>) -> Bool {
        return lhs.rawValue == rhs.rawValue
    }
}

extension Tagged: Decodable where RawValue: Decodable {
    public init(from decoder: Decoder) throws {
        do {
            self.init(rawValue: try decoder.singleValueContainer().decode(RawValue.self))
        } catch {
            self.init(rawValue: try .init(from: decoder))
        }
    }
}

extension Tagged: Encodable where RawValue: Encodable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(self.rawValue)
    }
}

extension Tagged: Hashable where V: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(rawValue.hashValue)
    }
}
