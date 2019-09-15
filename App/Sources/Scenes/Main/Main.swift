//
//  Main.swift
//  App
//
//  Created by Yu Tawata on 2019/05/04.
//

import Foundation
import Shared
import Domain
import Core

enum MainScene {
    struct State {
        var selected: CI

        var before: CI? {
            switch selected {
            case .travisci:
                return nil
            case .circleci:
                return .travisci
            case .bitrise:
                return .circleci
            }
        }

        var after: CI? {
            switch selected {
            case .travisci:
                return .circleci
            case .circleci:
                return .bitrise
            case .bitrise:
                return nil
            }
        }
    }

    enum Message {
        case update(CI)
    }

    struct Dependency {
    }
}

protocol MainViewPresenterProtocol {
    var state: MainScene.State { get }

    func subscribe(_ closure: @escaping (MainScene.State) -> Void)
    func unsubscribe()
    func dispatch(_ message: MainScene.Message)
}

class MainViewPresenter: MainViewPresenterProtocol {
    struct Context {
        var selected: CI
    }

    private(set) var state: MainScene.State {
        didSet {
            closure?(state)
        }
    }

    private var closure: ((MainScene.State) -> Void)?

    private let dependency: MainScene.Dependency

    init(_ context: Context, dependency: MainScene.Dependency) {
        self.state = .init(selected: context.selected)
        self.dependency = dependency
    }

    func subscribe(_ closure: @escaping (MainScene.State) -> Void) {
        self.closure = closure
        closure(state)
    }

    func unsubscribe() {
        self.closure = nil
    }

    func dispatch(_ message: MainScene.Message) {
        switch message {
        case .update(let ci):
            state.selected = ci
        }
    }
}
