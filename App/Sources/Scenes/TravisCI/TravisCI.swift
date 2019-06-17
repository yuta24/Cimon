//
//  TravisCI.swift
//  App
//
//  Created by Yu Tawata on 2019/05/04.
//

import Foundation
import ReactiveSwift
import TravisCIAPI
import Shared
import Domain

enum TravisCI {
    struct State {
        static var initial: State {
            return .init(isLoading: false, token: .none, builds: [], offset: 0)
        }

        var isLoading: Bool
        var token: TravisCIToken?
        var builds: [Build]
        var offset: Int?

        var isUnregistered: Bool {
            return token == nil
        }
    }

    enum Message {
        case fetch
        case fetchNext
        case token(String?)
    }

    struct Dependency {
        var network: NetworkServiceProtocol
        var store: StoreProtocol
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
            DispatchQueue.main.async {
                self.closure?(self.state)
            }
        }
    }

    private var closure: ((TravisCI.State) -> Void)?

    func load() -> Reader<TravisCI.Dependency, Void> {
        return .init({ [weak self] (dependency) in
            dependency.store.value(.travisCIToken, { (value) in
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
                guard self.condition(where: { !$0.state.isLoading }) else {
                    return
                }
                self?.state.isLoading = true
                dependency.network.response(Endpoint.Builds(limit: 25, offset: 0))
                    .on(failed: { (error) in
                        logger.debug(error)
                    }, disposed: {
                        self?.state.isLoading = false
                    }, value: { (response) in
                        logger.debug(response)
                        self?.state.builds = response.builds
                        self?.state.offset = response.pagination.next?.offset
                    })
                    .start()
            case .fetchNext:
                guard self.condition(where: { !$0.state.isLoading }) else {
                    return
                }
                guard let offset = self?.state.offset else {
                    return
                }
                self?.state.isLoading = true
                dependency.network.response(Endpoint.Builds(limit: 25, offset: offset))
                    .on(failed: { (error) in
                        logger.debug(error)
                    }, disposed: {
                        self?.state.isLoading = false
                    }, value: { (response) in
                        logger.debug(response)
                        self?.state.builds.append(contentsOf: response.builds)
                        self?.state.offset = response.pagination.next?.offset
                    })
                    .start()
            case .token(let raw):
                let token = raw.flatMap(TravisCIToken.init)
                dependency.store.set(token, for: .travisCIToken)
                self?.state.token = token
            }
        })
    }

    func route(event: TravisCI.Transition.Event) -> Reader<UIViewController, Void> {
        return .init({ (from) in
        })
    }
}
