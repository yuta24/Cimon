//
//  Store.swift
//  Shared
//
//  Created by Yu Tawata on 2019/09/19.
//

import Foundation

public class Store<Value, Action> {
    public private(set) var value: Value

    private let reducer: (inout Value, Action) -> Void

    public init(initial value: Value, reducer: @escaping (inout Value, Action) -> Void) {
        self.value = value
        self.reducer = reducer
    }

    public func dispatch(_ action: Action) {
        reducer(&value, action)
    }
}

public func combine<Value, Action>(_ reducers: (inout Value, Action) -> Void ... ) -> (inout Value, Action) -> Void {
    return { value, action in
        reducers.forEach { (reducer) in
            reducer(&value, action)
        }
    }
}

public func pullback<LocalValue, GlobalValue, LocalAction, GlobalAction>(_ reducer: @escaping (inout LocalValue, LocalAction) -> Void, value: WritableKeyPath<GlobalValue, LocalValue>, action: WritableKeyPath<GlobalAction, LocalAction?>) -> (inout GlobalValue, GlobalAction) -> Void {
    return { globalValue, globalAction in
        guard let localAction = globalAction[keyPath: action] else {
            return
        }
        reducer(&globalValue[keyPath: value], localAction)
    }
}
