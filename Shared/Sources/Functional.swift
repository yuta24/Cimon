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

public struct Tagged<T, V>: RawRepresentable {
    public var rawValue: V

    public init?(rawValue: V) {
        self.rawValue = rawValue
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
