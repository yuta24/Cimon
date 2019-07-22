//
//  Settings.swift
//  App
//
//  Created by Yu Tawata on 2019/07/10.
//

import Foundation
import SwiftUI
import Combine
import Shared
import Domain

class Settings: BindableObject {
    struct State {
        var tokens: [CI: String]

        static var initial: State {
            return .init(tokens: [:])
        }
    }

    enum Message {
        case update(value: String, for: CI)
    }

    struct Dependency {
        var store: StoreProtocol
    }

    let didChange = PassthroughSubject<State, Never>()

    private(set) var state: State = .initial {
        didSet {
            didChange.send(state)
        }
    }

    private let dependency: Dependency

    init(dependency: Dependency) {
        self.state.tokens[.travisci] = dependency.store.value(.travisCIToken)!.value
        self.state.tokens[.circleci] = dependency.store.value(.circleCIToken)!.value
        self.state.tokens[.bitrise] = dependency.store.value(.bitriseToken)!.value
        self.dependency = dependency
    }

    func dispatch(_ message: Message) {
        switch message {
        case .update(let value, let ci):
            switch ci {
            case .travisci:
                dependency.store.set(TravisCIToken(token: value), for: .travisCIToken)
            case .circleci:
                dependency.store.set(CircleCIToken(token: value), for: .circleCIToken)
            case .bitrise:
                dependency.store.set(BitriseToken(token: value), for: .bitriseToken)
            }

            state.tokens[ci] = value
        }
    }
}
