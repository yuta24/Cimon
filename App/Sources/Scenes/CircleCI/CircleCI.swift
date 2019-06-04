//
//  CircleCI.swift
//  App
//
//  Created by Yu Tawata on 2019/05/04.
//

import Foundation
import Promises
import CircleCIAPI
import Shared
import Domain

enum CircleCI {
    struct State {
        static var initial: State {
            return .init(isLoading: false, token: .none, builds: [], offset: 0)
        }

        var isLoading: Bool
        var token: CircleCIToken?
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

protocol CircleCIViewPresenterProtocol {
    var state: CircleCI.State { get }

    func load() -> Reader<CircleCI.Dependency, Void>
    func subscribe(_ closure: @escaping (CircleCI.State) -> Void)
    func unsubscribe()
    func dispatch(_ message: CircleCI.Message) -> Reader<CircleCI.Dependency, Void>

    func route(event: CircleCI.Transition.Event) -> Reader<UIViewController, Void>
}

class CircleCIViewPresenter: CircleCIViewPresenterProtocol {
    private(set) var state: CircleCI.State = .initial {
        didSet {
            closure?(state)
        }
    }

    private var closure: ((CircleCI.State) -> Void)?

    func load() -> Reader<CircleCI.Dependency, Void> {
        return .init({ [weak self] (dependency) in
            dependency.store.value(.circleCIToken, { (value) in
                self?.state.token = value
            })
        })
    }

    func subscribe(_ closure: @escaping (CircleCI.State) -> Void) {
        self.closure = closure
        closure(state)
    }

    func unsubscribe() {
        self.closure = nil
    }

    func dispatch(_ message: CircleCI.Message) -> Reader<CircleCI.Dependency, Void> {
        return .init({ [weak self] (dependency) in
            switch message {
            case .fetch:
                guard self.condition(where: { !$0.state.isLoading }) else {
                    return
                }
                self?.state.isLoading = true
                dependency.network.response(Endpoint.RecentBuilds(limit: 25, offset: 0, shallow: false))
                    .always {
                        self?.state.isLoading = false
                    }
                    .then({ (response) in
                        logger.debug(response)
                        self?.state.builds = response
                        self?.state.offset = self?.state.builds.count
                    })
                    .catch({ (error) in
                        logger.debug(error)
                    })
            case .fetchNext:
                guard self.condition(where: { !$0.state.isLoading }) else {
                    return
                }
                guard let offset = self?.state.offset else {
                    return
                }
                self?.state.isLoading = true
                dependency.network.response(Endpoint.RecentBuilds(limit: 25, offset: offset, shallow: false))
                    .always {
                        self?.state.isLoading = false
                    }
                    .then({ (response) in
                        logger.debug(response)
                        self?.state.builds.append(contentsOf: response)
                        self?.state.offset = response.isEmpty ? nil : self?.state.builds.count
                    })
                    .catch({ (error) in
                        logger.debug(error)
                    })
            case .token(let raw):
                let token = raw.flatMap(CircleCIToken.init)
                dependency.store.set(token, for: .circleCIToken)
                self?.state.token = token
            }
        })
    }

    func route(event: CircleCI.Transition.Event) -> Reader<UIViewController, Void> {
        return .init({ (from) in
        })
    }
}
