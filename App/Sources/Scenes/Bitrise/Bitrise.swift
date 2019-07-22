//
//  Bitrise.swift
//  App
//
//  Created by Yu Tawata on 2019/05/04.
//

import Foundation
import BitriseAPI
import Shared
import Domain

enum BitriseScene {
    struct State {
        static var initial: State {
            return .init(isLoading: false, token: .none, builds: [], next: .none)
        }

        var isLoading: Bool
        var token: BitriseToken?
        var builds: [BuildListAllResponseItemModel]
        var next: String?

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
        var fetchUseCase: FetchBuildsFromBitriseProtocol
        var store: StoreProtocol
    }

    enum Transition {
        enum Event {
        }
    }
}

protocol BitriseViewPresenterProtocol {
    var state: BitriseScene.State { get }

    func subscribe(_ closure: @escaping (BitriseScene.State) -> Void)
    func unsubscribe()
    func dispatch(_ message: BitriseScene.Message)

    func route(event: BitriseScene.Transition.Event) -> Reader<UIViewController, Void>
}

class BitriseViewPresenter: BitriseViewPresenterProtocol {
    private(set) var state: BitriseScene.State = .initial {
        didSet {
            DispatchQueue.main.async {
                self.closure?(self.state)
            }
        }
    }

    private var closure: ((BitriseScene.State) -> Void)?

    private let dependency: BitriseScene.Dependency

    init(dependency: BitriseScene.Dependency) {
        self.dependency = dependency
    }

    func subscribe(_ closure: @escaping (BitriseScene.State) -> Void) {
        self.closure = closure
        closure(state)
    }

    func unsubscribe() {
        self.closure = nil
    }

    func dispatch(_ message: BitriseScene.Message) {
        switch message {
        case .load:
            dependency.store.value(.bitriseToken, { [weak self] (value) in
                self?.state.token = value
            })
        case .fetch:
            guard !state.isLoading else {
                return
            }
            state.isLoading = true
            dependency.fetchUseCase.run(ownerSlug: .none, isOnHold: .none, status: .none, next: .none, limit: 25)
                .on(failed: { [weak self] (error) in
                    logger.debug(error)
                    self?.state.isLoading = false
                }, value: { [weak self] (response) in
                    logger.debug(response)
                    if let data = response.data {
                        self?.state.builds = data
                    }
                    self?.state.next = response.paging?.next
                    self?.state.isLoading = false
                })
                .start()
        case .fetchNext:
            guard !state.isLoading else {
                return
            }
            guard let next = state.next else {
                return
            }
            state.isLoading = true
            dependency.fetchUseCase.run(ownerSlug: .none, isOnHold: .none, status: .none, next: next, limit: 25)
                .on(failed: { [weak self] (error) in
                    logger.debug(error)
                    self?.state.isLoading = false
                }, value: { [weak self] (response) in
                    logger.debug(response)
                    if let data = response.data {
                        self?.state.builds.append(contentsOf: data)
                    }
                    self?.state.next = response.paging?.next
                    self?.state.isLoading = false
                })
                .start()
        case .token(let raw):
            let token = raw.flatMap(BitriseToken.init)
            dependency.store.set(token, for: .bitriseToken)
            state.token = token
        }
    }

    func route(event: BitriseScene.Transition.Event) -> Reader<UIViewController, Void> {
        return .init({ (from) in
        })
    }
}
