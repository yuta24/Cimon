//
//  CircleCI.swift
//  App
//
//  Created by Yu Tawata on 2019/05/04.
//

import Foundation
import CircleCIAPI
import Shared
import Domain

enum CircleCIScene {
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
        case load
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
    var state: CircleCIScene.State { get }

    func subscribe(_ closure: @escaping (CircleCIScene.State) -> Void)
    func unsubscribe()
    func dispatch(_ message: CircleCIScene.Message) -> Reader<CircleCIScene.Dependency, Void>

    func route(event: CircleCIScene.Transition.Event) -> Reader<UIViewController, Void>
}

class CircleCIViewPresenter: CircleCIViewPresenterProtocol {
    private(set) var state: CircleCIScene.State = .initial {
        didSet {
            DispatchQueue.main.async {
                self.closure?(self.state)
            }
        }
    }

    private var closure: ((CircleCIScene.State) -> Void)?

    func subscribe(_ closure: @escaping (CircleCIScene.State) -> Void) {
        self.closure = closure
        closure(state)
    }

    func unsubscribe() {
        self.closure = nil
    }

    func dispatch(_ message: CircleCIScene.Message) -> Reader<CircleCIScene.Dependency, Void> {
        return .init({ [weak self] (dependency) in
            switch message {
            case .load:
                dependency.store.value(.circleCIToken, { (value) in
                    self?.state.token = value
                })
            case .fetch:
                guard self.condition(where: { !$0.state.isLoading }) else {
                    return
                }
                self?.state.isLoading = true
                dependency.network.response(Endpoint.RecentBuilds(limit: 25, offset: 0, shallow: false))
                    .on(failed: { (error) in
                        logger.debug(error)
                        self?.state.isLoading = false
                    }, value: { (response) in
                        logger.debug(response)
                        self?.state.builds = response
                        self?.state.offset = self?.state.builds.count
                        self?.state.isLoading = false
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
                dependency.network.response(Endpoint.RecentBuilds(limit: 25, offset: offset, shallow: false))
                    .on(failed: { (error) in
                        logger.debug(error)
                        self?.state.isLoading = false
                    }, value: { (response) in
                        logger.debug(response)
                        self?.state.builds.append(contentsOf: response)
                        self?.state.offset = response.isEmpty ? nil : self?.state.builds.count
                        self?.state.isLoading = false
                    })
                    .start()
            case .token(let raw):
                let token = raw.flatMap(CircleCIToken.init)
                dependency.store.set(token, for: .circleCIToken)
                self?.state.token = token
            }
        })
    }

    func route(event: CircleCIScene.Transition.Event) -> Reader<UIViewController, Void> {
        return .init({ (from) in
        })
    }
}
