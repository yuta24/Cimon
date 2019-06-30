//
//  LoadingState.swift
//  Shared
//
//  Created by Yu Tawata on 2019/05/05.
//

import Foundation

public enum LoadingState<T, E> where E: Swift.Error {
    case idle
    case loading(T?)
    case loaded(T)
    case error(T?, E)

    public var isLoading: Bool {
        switch self {
        case .idle:
            return false
        case .loading:
            return true
        case .loaded:
            return false
        case .error:
            return false
        }
    }

    public var value: T? {
        switch self {
        case .idle:
            return nil
        case .loading(let value):
            return value
        case .loaded(let value):
            return value
        case .error(let value, _):
            return value
        }
    }

    public var error: E? {
        switch self {
        case .idle:
            return nil
        case .loading:
            return nil
        case .loaded:
            return nil
        case .error(_, let error):
            return error
        }
    }
}

public extension LoadingState {
    enum Mutator {
        case toLoading
        case toLoaded(T)
        case toError(E)
    }
}

public func mutate<T, E>(_ state: LoadingState<T, E>, _ mutator: LoadingState<T, E>.Mutator) -> LoadingState<T, E> {
    switch (state, mutator) {
    case (.idle, .toLoading):
        return .loading(nil)
    case (.loading(let value), .toLoading):
        return .loading(value)
    case (.loaded(let value), .toLoading):
        return .loading(value)
    case (.error(let value, _), .toLoading):
        return .loading(value)

    case (.idle, .toLoaded(let value)):
        return .loaded(value)
    case (.loading, .toLoaded(let value)):
        return .loaded(value)
    case (.loaded, .toLoaded(let value)):
        return .loaded(value)
    case (.error, .toLoaded(let value)):
        return .loaded(value)

    case (.idle, .toError(let error)):
        return .error(nil, error)
    case (.loading(let value), .toError(let error)):
        return .error(value, error)
    case (.loaded(let value), .toError(let error)):
        return .error(value, error)
    case (.error(let value, _), .toError(let error)):
        return .error(value, error)
    }
}

public extension LoadingState {
    var shouldHideLoading: Bool {
        switch self {
        case .idle, .loading(.some), .loaded, .error:
            return true
        case .loading(.none):
            return false
        }
    }

    var shouldHideError: Bool {
        switch self {
        case .idle, .loading, .loaded, .error(.some, _):
            return true
        case .error(.none, _):
            return false
        }
    }
}
