//
//  TravisCI.swift
//  App
//
//  Created by Yu Tawata on 2019/05/04.
//

import Foundation
import Promises
import TravisCIAPI
import Shared
import Domain

enum TravisCI {
    struct State {
        static var initial: State {
            return .init(token: .none, builds: [])
        }

        var token: TravisCIToken?
        var builds: [Build]

        var isUnregistered: Bool {
            return token == nil
        }
    }

    enum Message {
        case fetch
        case token(String?)
    }

    struct Dependency {
        var network: NetworkServiceProtocol
        var storage: StorageProtocol
    }

    enum Transition {
        enum Event {
        }
    }
}

protocol TravisCIViewPresenterProtocol {
    var state: TravisCI.State { get }

    func load() -> Reader<TravisCI.Dependency, Void>
    func subscribe(_ closure: @escaping (TravisCI.State) -> Void)
    func unsubscribe()
    func dispatch(_ message: TravisCI.Message) -> Reader<TravisCI.Dependency, Void>

    func route(event: TravisCI.Transition.Event) -> Reader<UIViewController, Void>
}

class TravisCIViewPresenter: TravisCIViewPresenterProtocol {
    private(set) var state: TravisCI.State = .initial {
        didSet {
            closure?(state)
        }
    }

    private var closure: ((TravisCI.State) -> Void)?

    func load() -> Reader<TravisCI.Dependency, Void> {
        return .init({ [weak self] (dependency) in
            dependency.storage.value(.travisCIToken, { (value) in
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

    func dispatch(_ message: TravisCI.Message) -> Reader<TravisCI.Dependency, Void> {
        return .init({ [weak self] (dependency) in
            switch message {
            case .fetch:
                dependency.network.response(Endpoint.Builds(limit: 10, offset: 0))
                    .then({ (response) in
                        logger.debug(response)
                        self?.state.builds = response.builds
                    })
                    .catch({ (error) in
                        logger.debug(error)
                    })
            case .token(let raw):
                let token = raw.flatMap(TravisCIToken.init)
                dependency.storage.set(token, for: .travisCIToken)
                self?.state.token = token
            }
        })
    }

    func route(event: TravisCI.Transition.Event) -> Reader<UIViewController, Void> {
        return .init({ (from) in
        })
    }
}
