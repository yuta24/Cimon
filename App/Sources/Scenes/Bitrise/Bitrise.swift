//
//  Bitrise.swift
//  App
//
//  Created by Yu Tawata on 2019/05/04.
//

import Foundation
import Promises
import BitriseAPI
import Shared
import Domain

enum Bitrise {
    struct State {
        static var initial: State {
            return .init(isLoading: false, token: .none, builds: [], next: nil)
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
        case fetch
        case fetchNext
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

protocol BitriseViewPresenterProtocol {
    var state: Bitrise.State { get }

    func load() -> Reader<Bitrise.Dependency, Void>
    func subscribe(_ closure: @escaping (Bitrise.State) -> Void)
    func unsubscribe()
    func dispatch(_ message: Bitrise.Message) -> Reader<Bitrise.Dependency, Void>

    func route(event: Bitrise.Transition.Event) -> Reader<UIViewController, Void>
}

class BitriseViewPresenter: BitriseViewPresenterProtocol {
    private(set) var state: Bitrise.State = .initial {
        didSet {
            closure?(state)
        }
    }

    private var closure: ((Bitrise.State) -> Void)?

    func load() -> Reader<Bitrise.Dependency, Void> {
        return .init({ [weak self] (dependency) in
            dependency.storage.value(.bitriseToken, { (value) in
                self?.state.token = value
            })
        })
    }

    func subscribe(_ closure: @escaping (Bitrise.State) -> Void) {
        self.closure = closure
        closure(state)
    }

    func unsubscribe() {
        self.closure = nil
    }

    func dispatch(_ message: Bitrise.Message) -> Reader<Bitrise.Dependency, Void> {
        return .init({ [weak self] (dependency) in
            switch message {
            case .fetch:
                guard self.condition(where: { !$0.state.isLoading }) else {
                    return
                }
                self?.state.isLoading = true
                dependency.network.response(Endpoint.Builds.init(ownerSlug: nil, isOnHold: nil, status: nil, next: nil))
                    .always {
                        self?.state.isLoading = false
                    }
                    .then({ (response) in
                        logger.debug(response)
                        if let data = response.data {
                            self?.state.builds = data
                        }
                        self?.state.next = response.paging?.next
                    })
                    .catch({ (error) in
                        logger.debug(error)
                    })
            case .fetchNext:
                guard self.condition(where: { !$0.state.isLoading }) else {
                    return
                }
                guard let next = self?.state.next else {
                    return
                }
                self?.state.isLoading = true
                dependency.network.response(Endpoint.Builds.init(ownerSlug: nil, isOnHold: nil, status: nil, next: next))
                    .always {
                        self?.state.isLoading = false
                    }
                    .then({ (response) in
                        logger.debug(response)
                        if let data = response.data {
                            self?.state.builds.append(contentsOf: data)
                        }
                        self?.state.next = response.paging?.next
                    })
                    .catch({ (error) in
                        logger.debug(error)
                    })
            case .token(let raw):
                let token = raw.flatMap(BitriseToken.init)
                dependency.storage.set(token, for: .bitriseToken)
                self?.state.token = token
            }
        })
    }

    func route(event: Bitrise.Transition.Event) -> Reader<UIViewController, Void> {
        return .init({ (from) in
        })
    }
}
