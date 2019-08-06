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

enum TravisCIScene {
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
        case load
        case fetch
        case fetchNext
        case token(String?)
    }

    struct Dependency {
        var fetchUseCase: FetchBuildsFromTravisCIProtocol
        var store: StoreProtocol
    }

    enum Transition {
        enum Event {
        }
    }
}

protocol TravisCIViewPresenterProtocol {
    var state: TravisCIScene.State { get }

    func subscribe(_ closure: @escaping (TravisCIScene.State) -> Void)
    func unsubscribe()
    func dispatch(_ message: TravisCIScene.Message)

    func route(event: TravisCIScene.Transition.Event) -> Reader<UIViewController, Void>
}

class TravisCIViewPresenter: TravisCIViewPresenterProtocol {
    private(set) var state: TravisCIScene.State = .initial {
        didSet {
            DispatchQueue.main.async {
                self.closure?(self.state)
            }
        }
    }

    private var closure: ((TravisCIScene.State) -> Void)?

    private let dependency: TravisCIScene.Dependency

    init(dependency: TravisCIScene.Dependency) {
        self.dependency = dependency
    }

    func subscribe(_ closure: @escaping (TravisCIScene.State) -> Void) {
        self.closure = closure
        closure(state)
    }

    func unsubscribe() {
        self.closure = nil
    }

    func dispatch(_ message: TravisCIScene.Message) {
        switch message {
        case .load:
            dependency.store.value(.travisCIToken, { [weak self] (value) in
                self?.state.token = value
            })
        case .fetch:
            guard !state.isLoading else {
                return
            }
            state.isLoading = true
            dependency.fetchUseCase.run(limit: 25, offset: 0)
                .on(failed: { [weak self] (error) in
                    logger.debug(error)
                    self?.state.isLoading = false
                }, value: { [weak self] (response) in
                    logger.debug(response)
                    self?.state.builds = response.builds
                    self?.state.offset = response.pagination.next?.offset
                    self?.state.isLoading = false
                })
                .start()
        case .fetchNext:
            guard !state.isLoading else {
                return
            }
            guard let offset = state.offset else {
                return
            }
            state.isLoading = true
            dependency.fetchUseCase.run(limit: 25, offset: offset)
                .on(failed: { [weak self] (error) in
                    logger.debug(error)
                    self?.state.isLoading = false
                }, value: { [weak self] (response) in
                    logger.debug(response)
                    self?.state.builds.append(contentsOf: response.builds)
                    self?.state.offset = response.pagination.next?.offset
                    self?.state.isLoading = false
                })
                .start()
        case .token(let raw):
            let token = raw.flatMap(TravisCIToken.init)
            dependency.store.set(token, for: .travisCIToken)
            state.token = token
        }
    }

    func route(event: TravisCIScene.Transition.Event) -> Reader<UIViewController, Void> {
        return .init({ (from) in
        })
    }
}
