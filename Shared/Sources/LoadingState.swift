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
