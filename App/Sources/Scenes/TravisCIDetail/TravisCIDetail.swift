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

enum TravisCIDetailScene {
    struct State {
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

    enum Message {
        case fetch
    }

    struct Dependency {
        var interactor: TravisCIDetailInteractorProtocol
        var store: StoreProtocol
        var network: NetworkServiceProtocol
    }

    enum Transition {
        enum Event {
        }
    }
}

protocol TravisCIDetailViewPresenterProtocol {
    var state: TravisCIDetailScene.State { get }

    func subscribe(_ closure: @escaping (TravisCIDetailScene.State) -> Void)
    func unsubscribe()
    func dispatch(_ message: TravisCIDetailScene.Message)

    func route(from: UIViewController, event: TravisCIDetailScene.Transition.Event)
}

class TravisCIDetailViewPresenter: TravisCIDetailViewPresenterProtocol {
    struct Context {
        var buildId: Int
    }

    private(set) var state: TravisCIDetailScene.State = .initial {
        didSet {
            DispatchQueue.main.async {
                self.closure?(self.state)
            }
        }
    }

    private var closure: ((TravisCIDetailScene.State) -> Void)?

    private let context: Context
    private let dependency: TravisCIDetailScene.Dependency

    init(_ context: Context, dependency: TravisCIDetailScene.Dependency) {
        self.context = context
        self.dependency = dependency
    }

    func subscribe(_ closure: @escaping (TravisCIDetailScene.State) -> Void) {
        self.closure = closure
        closure(state)
    }

    func unsubscribe() {
        self.closure = nil
    }

    func dispatch(_ message: TravisCIDetailScene.Message) {
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

    func route(from: UIViewController, event: TravisCIDetailScene.Transition.Event) {
    }
}
