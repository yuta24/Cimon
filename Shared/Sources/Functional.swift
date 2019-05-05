//
//  Functional.swift
//  Shared
//
//  Created by Yu Tawata on 2019/05/04.
//

import Foundation

public func apply<T>(_ target: T, _ closure: (T) -> Void) -> T where T: AnyObject {
    closure(target)
    return target
}

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

public struct Reader<E, A> {
    let closure: (E) -> A

    public init(_ closure: @escaping (E) -> A) {
        self.closure = closure
    }

    public func execute(_ environment: E) -> A {
        return closure(environment)
    }
}
