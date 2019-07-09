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
        var isTravisCI: Bool
        var isCircleCI: Bool
        var isBitrise: Bool

        static var initial: State {
            return .init(isTravisCI: false, isCircleCI: false, isBitrise: false)
        }
    }

    enum Message {
        case update(value: Bool, path: WritableKeyPath<State, Bool>)
    }

    struct Dependency {
        var store: StoreProtocol
    }

    let didChange = PassthroughSubject<State, Never>()

    private(set) var state: State {
        didSet {
            didChange.send(state)
        }
    }
    private let dependency: Dependency

    init(dependency: Dependency) {
        self.state = .initial
        self.dependency = dependency
    }

    func dispatch(_ message: Message) {
        logger.debug(message)
        switch message {
        case .update(let value, let path):
            state[keyPath: path] = value
        }
    }
}
