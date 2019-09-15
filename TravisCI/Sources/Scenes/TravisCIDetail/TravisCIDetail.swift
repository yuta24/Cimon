//
//  TravisCIDetail.swift
//  App
//
//  Created by Yu Tawata on 2019/08/11.
//

import Foundation
import ReactiveSwift
import TravisCIAPI
import Shared
import Domain
import Core

public enum TravisCIDetailScene {
    public struct State {
        static var initial: State {
            return .init(isLoading: false, token: .none, detail: .none)
        }

        var isLoading: Bool
        var token: TravisCIToken?
        var detail: (Standard.Build, [Standard.Job])?

        var isUnregistered: Bool {
            return token == nil
        }
    }

    public struct Dependency {
        public var interactor: TravisCIDetailInteractorProtocol
        public var store: StoreProtocol
        public var network: NetworkServiceProtocol

        public init(
            interactor: TravisCIDetailInteractorProtocol,
            store: StoreProtocol,
            network: NetworkServiceProtocol) {
            self.interactor = interactor
            self.store = store
            self.network = network
        }
    }

    public enum Message {
        case fetch
    }
}

public protocol TravisCIDetailViewPresenterProtocol {
    var state: TravisCIDetailScene.State { get }

    func subscribe(_ closure: @escaping (TravisCIDetailScene.State) -> Void)
    func unsubscribe()
    func dispatch(_ message: TravisCIDetailScene.Message)

    func route(from: UIViewController, event: TravisCIDetail.Transition.Event)
}

public class TravisCIDetailViewPresenter: TravisCIDetailViewPresenterProtocol {
    public struct Context {
        public var buildId: Int

        public init(buildId: Int) {
            self.buildId = buildId
        }
    }

    public private(set) var state: TravisCIDetailScene.State = .initial {
        didSet {
            DispatchQueue.main.async {
                self.closure?(self.state)
            }
        }
    }

    private var closure: ((TravisCIDetailScene.State) -> Void)?

    private let context: Context
    private let dependency: TravisCIDetailScene.Dependency

    public init(_ context: Context, dependency: TravisCIDetailScene.Dependency) {
        self.context = context
        self.dependency = dependency
    }

    public func subscribe(_ closure: @escaping (TravisCIDetailScene.State) -> Void) {
        self.closure = closure
        closure(state)
    }

    public func unsubscribe() {
        self.closure = nil
    }

    public func dispatch(_ message: TravisCIDetailScene.Message) {
        switch message {
        case .fetch:
            guard !state.isLoading else {
                return
            }
            state.isLoading = true
            dependency.interactor.fetchDetail(buildId: context.buildId)
                .on(failed: { [weak self] (error) in
                    logger.debug(error)
                    self?.state.isLoading = false
                }, value: { [weak self] (response) in
                    logger.debug(response)
                    self?.state.isLoading = false
                    self?.state.detail = response
                })
                .start()
        }
    }

    public func route(from: UIViewController, event: TravisCIDetail.Transition.Event) {
    }
}
