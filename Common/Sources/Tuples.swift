//
//  Tuples.swift
//  Common
//
//  Created by Yu Tawata on 2020/08/02.
//

import Foundation

public struct Tuple2<S, T> {
    public var value0: S
    public var value1: T

    public init(value0: S, value1: T) {
        self.value0 = value0
        self.value1 = value1
    }
}

extension Tuple2: Equatable where S: Equatable, T: Equatable {}

extension Tuple2: Hashable where S: Hashable, T: Hashable {}

public struct Tuple3<S, T, U> {
    public var value0: S
    public var value1: T
    public var value2: U

    public init(value0: S, value1: T, value2: U) {
        self.value0 = value0
        self.value1 = value1
        self.value2 = value2
    }
}

extension Tuple3: Equatable where S: Equatable, T: Equatable, U: Equatable {}

extension Tuple3: Hashable where S: Hashable, T: Hashable, U: Hashable {}

public struct Tuple4<S, T, U, V> {
    public var value0: S
    public var value1: T
    public var value2: U
    public var value3: V

    public init(value0: S, value1: T, value2: U, value3: V) {
        self.value0 = value0
        self.value1 = value1
        self.value2 = value2
        self.value3 = value3
    }
}

extension Tuple4: Equatable where S: Equatable, T: Equatable, U: Equatable, V: Equatable {}

extension Tuple4: Hashable where S: Hashable, T: Hashable, U: Hashable, V: Hashable {}
