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
        var network: NetworkServiceProtocol
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
    func dispatch(_ message: BitriseScene.Message) -> Reader<BitriseScene.Dependency, Void>

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

    func subscribe(_ closure: @escaping (BitriseScene.State) -> Void) {
        self.closure = closure
        closure(state)
    }

    func unsubscribe() {
        self.closure = nil
    }

    func dispatch(_ message: BitriseScene.Message) -> Reader<BitriseScene.Dependency, Void> {
        return .init({ [weak self] (dependency) in
            switch message {
            case .load:
                dependency.store.value(.bitriseToken, { (value) in
                    self?.state.token = value
                })
            case .fetch:
                guard self.condition(where: { !$0.state.isLoading }) else {
                    return
                }
                self?.state.isLoading = true
                dependency.network.response(Endpoint.Builds(ownerSlug: nil, isOnHold: nil, status: nil, next: nil, limit: 25))
                    .on(failed: { (error) in
                        logger.debug(error)
                    }, disposed: {
                        self?.state.isLoading = false
                    }, value: { (response) in
                        logger.debug(response)
                        if let data = response.data {
                            self?.state.builds = data
                        }
                        self?.state.next = response.paging?.next
                    })
                    .start()
            case .fetchNext:
                guard self.condition(where: { !$0.state.isLoading }) else {
                    return
                }
                guard let next = self?.state.next else {
                    return
                }
                self?.state.isLoading = true
                dependency.network.response(Endpoint.Builds(ownerSlug: nil, isOnHold: nil, status: nil, next: next, limit: 25))
                    .on(failed: { (error) in
                        logger.debug(error)
                    }, disposed: {
                        self?.state.isLoading = false
                    }, value: { (response) in
                        logger.debug(response)
                        if let data = response.data {
                            self?.state.builds.append(contentsOf: data)
                        }
                        self?.state.next = response.paging?.next
                    })
                    .start()
            case .token(let raw):
                let token = raw.flatMap(BitriseToken.init)
                dependency.store.set(token, for: .bitriseToken)
                self?.state.token = token
            }
        })
    }

    func route(event: BitriseScene.Transition.Event) -> Reader<UIViewController, Void> {
        return .init({ (from) in
        })
    }
}
