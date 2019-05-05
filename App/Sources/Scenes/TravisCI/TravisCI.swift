//
//  TravisCI.swift
//  App
//
//  Created by Yu Tawata on 2019/05/04.
//

import Foundation
import Promises
import Shared
import Domain

enum TravisCI {
    struct State {
        static var initial: State {
            return .init(loading: .idle, token: .none)
        }

        var loading: LoadingState<Void, Never>
        var token: TravisCIToken?

        var isUnregistered: Bool {
            return token == nil
        }
    }

    enum Message {
        case token(String?)
    }

    enum Transition {
        enum Event {
        }
    }
}

protocol TravisCIViewPresenterProtocol {
    var state: TravisCI.State { get }

    func load() -> Reader<Storage, Void>
    func subscribe(_ closure: @escaping (TravisCI.State) -> Void)
    func unsubscribe()
    func dispatch(_ message: TravisCI.Message) -> Reader<Storage, Void>

    func route(event: TravisCI.Transition.Event) -> Reader<UIViewController, Void>
}

class TravisCIViewPresenter: TravisCIViewPresenterProtocol {
    private(set) var state: TravisCI.State = .initial {
        didSet {
            closure?(state)
        }
    }

    private var closure: ((TravisCI.State) -> Void)?

    func load() -> Reader<Storage, Void> {
        return .init({ [weak self] (storage) in
            storage.value(.travisCIToken, { (value) in
                self?.state.token = value
            })
        })
    }

    func subscribe(_ closure: @escaping (TravisCI.State) -> Void) {
        self.closure = closure
        closure(state)
    }

    func unsubscribe() {
        self.closure = nil
    }

    func dispatch(_ message: TravisCI.Message) -> Reader<Storage, Void> {
        return .init({ [weak self] (storage) in
            switch message {
            case .token(let raw):
                let token = raw.flatMap(TravisCIToken.init)
                storage.set(token, for: .travisCIToken)
                self?.state.token = token
            }
        })
    }

    func route(event: TravisCI.Transition.Event) -> Reader<UIViewController, Void> {
        return .init({ (from) in
        })
    }
}
