//
//  AppState.swift
//  App
//
//  Created by Yu Tawata on 2019/09/19.
//

import Foundation
import Domain

public struct AppState {
    public var travisCIToken: TravisCIToken?
    public var circleCIToken: CircleCIToken?
    public var bitriseToken: BitriseToken?

    public init(
        travisCIToken: TravisCIToken?,
        circleCIToken: CircleCIToken?,
        bitriseToken: BitriseToken?) {
        self.travisCIToken = travisCIToken
        self.circleCIToken = circleCIToken
        self.bitriseToken = bitriseToken
    }
}

extension AppState {
    public var initial: AppState {
        return .init(
            travisCIToken: nil,
            circleCIToken: nil,
            bitriseToken: nil)
    }
}

public enum AppAction {
    public enum SubAction {
        case travisCI
        case circleCI
        case bitrise
    }

    case load
    case sub(SubAction)
}

public let appReducer: (inout AppState, AppAction) -> Void = { _, _ in
}
