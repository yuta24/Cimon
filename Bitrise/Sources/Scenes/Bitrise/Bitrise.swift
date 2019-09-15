//
//  Bitrise.swift
//  App
//
//  Created by Yu Tawata on 2019/05/04.
//

import Foundation
import UIKit
import BitriseAPI
import Shared
import Domain
import Core

public enum BitriseScene {
    public struct State {
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

    public struct Dependency {
        public var fetchUseCase: FetchBuildsFromBitriseProtocol
        public var store: StoreProtocol
        public var network: NetworkServiceProtocol
        public var route: (UIViewController, Bitrise.Transition.Event) -> Void

        public init(
            fetchUseCase: FetchBuildsFromBitriseProtocol,
            store: StoreProtocol,
            network: NetworkServiceProtocol,
            route: @escaping (UIViewController, Bitrise.Transition.Event) -> Void) {
            self.fetchUseCase = fetchUseCase
            self.store = store
            self.network = network
            self.route = route
        }
    }

    public enum Message {
        case load
        case fetch
        case fetchNext
        case token(String?)
    }
}

public protocol BitriseViewPresenterProtocol {
    var state: BitriseScene.State { get }

    func subscribe(_ closure: @escaping (BitriseScene.State) -> Void)
    func unsubscribe()
    func dispatch(_ message: BitriseScene.Message)

    func route(from: UIViewController, event: Bitrise.Transition.Event)
}

public class BitriseViewPresenter: BitriseViewPresenterProtocol {
    public private(set) var state: BitriseScene.State = .initial {
        didSet {
            DispatchQueue.main.async {
                self.closure?(self.state)
            }
        }
    }

    private var closure: ((BitriseScene.State) -> Void)?

    private let dependency: BitriseScene.Dependency

    public init(dependency: BitriseScene.Dependency) {
        self.dependency = dependency
    }

    public func subscribe(_ closure: @escaping (BitriseScene.State) -> Void) {
        self.closure = closure
        closure(state)
    }

    public func unsubscribe() {
        self.closure = nil
    }

    public func dispatch(_ message: BitriseScene.Message) {
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

    public func route(from: UIViewController, event: Bitrise.Transition.Event) {
        dependency.route(from, event)
    }
}
