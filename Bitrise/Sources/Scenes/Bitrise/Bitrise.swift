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

    public enum Message {
        case load
        case fetch
        case fetchNext
        case token(String?)
    }

    public enum Transition {
        public enum Event {
            case detail(repository: String, build: String)
        }
    }
}

public protocol BitriseViewPresenterProtocol {
    var state: BitriseScene.State { get }

    func subscribe(_ closure: @escaping (BitriseScene.State) -> Void)
    func unsubscribe()
    func dispatch(_ message: BitriseScene.Message)

    func route(from: UIViewController, event: BitriseScene.Transition.Event)
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

    private let dependency: Bitrise.Dependency

    public init(dependency: Bitrise.Dependency) {
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

    public func route(from: UIViewController, event: BitriseScene.Transition.Event) {
        switch event {
        case .detail(let repository, let build):
            let controller = dependency.sceneFactory.bitriseDetail(context: .init(appSlug: repository, buildSlug: build), with: .init(store: dependency.store, network: dependency.network))
//                Scenes.bitriseDetail.execute(.init(network: self.dependency.network, store: self.dependency.store, presenter: presenter))
            from.navigationController?.pushViewController(controller, animated: true)
        }
    }
}
