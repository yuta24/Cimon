//
//  Main.swift
//  App
//
//  Created by Yu Tawata on 2019/05/04.
//

import Foundation
import Shared
import Domain

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

    enum Transition {
        enum Event {
            case settings
        }
    }
}

protocol MainViewPresenterProtocol {
    var state: MainScene.State { get }

    func subscribe(_ closure: @escaping (MainScene.State) -> Void)
    func unsubscribe()
    func dispatch(_ message: MainScene.Message)

    func route(event: MainScene.Transition.Event) -> Reader<UIViewController, Void>
}

class MainViewPresenter: MainViewPresenterProtocol {
    private(set) var state: MainScene.State {
        didSet {
            closure?(state)
        }
    }

    private var closure: ((MainScene.State) -> Void)?

    init(ci: CI) {
        self.state = .init(selected: ci)
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

    func route(event: MainScene.Transition.Event) -> Reader<UIViewController, Void> {
        return .init({ (from) in
            switch event {
            case .settings:
                let controller = Scenes.settings.execute(.init())
                let navigation = UINavigationController(rootViewController: controller, hasClose: true)
                from.present(navigation, animated: true, completion: .none)
            }
        })
    }
}
