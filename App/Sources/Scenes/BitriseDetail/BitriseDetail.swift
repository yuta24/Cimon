//
//  BitriseDetail.swift
//  App
//
//  Created by Yu Tawata on 2019/07/01.
//

import Foundation
import ReactiveSwift
import BitriseAPI
import Shared
import Domain

enum BitriseDetailScene {
    struct State {
        static var initial: State {
            return .init(isLoading: false, token: .none, log: .none)
        }

        var isLoading: Bool
        var token: BitriseToken?
        var log: BuildLogInfoResponseModel?

        var isUnregistered: Bool {
            return token == nil
        }
    }

    enum Message {
        case fetch
    }

    struct Dependency {
        var store: StoreProtocol
        var network: NetworkServiceProtocol
    }

    enum Transition {
        enum Event {
        }
    }
}

protocol BitriseDetailViewPresenterProtocol {
    var state: BitriseDetailScene.State { get }

    func subscribe(_ closure: @escaping (BitriseDetailScene.State) -> Void)
    func unsubscribe()
    func dispatch(_ message: BitriseDetailScene.Message)

    func route(from: UIViewController, event: BitriseDetailScene.Transition.Event)
}

class BitriseDetailViewPresenter: BitriseDetailViewPresenterProtocol {
    struct Context {
        var appSlug: String
        var buildSlug: String
    }

    private(set) var state: BitriseDetailScene.State = .initial {
        didSet {
            DispatchQueue.main.async {
                self.closure?(self.state)
            }
        }
    }

    private var closure: ((BitriseDetailScene.State) -> Void)?
    private let context: Context

    private let dependency: BitriseDetailScene.Dependency

    init(_ context: Context, dependency: BitriseDetailScene.Dependency) {
        self.context = context
        self.dependency = dependency
    }

    func subscribe(_ closure: @escaping (BitriseDetailScene.State) -> Void) {
        self.closure = closure
        closure(state)
    }

    func unsubscribe() {
        self.closure = nil
    }

    func dispatch(_ message: BitriseDetailScene.Message) {
        switch message {
        case .fetch:
            guard !state.isLoading else {
                return
            }
            state.isLoading = true
            dependency.network.response(Endpoint.BuildLogRequest(appSlug: self.context.appSlug, buildSlug: self.context.buildSlug))
                .on(failed: { [weak self] (error) in
                    logger.debug(error)
                    self?.state.isLoading = false
                }, value: { [weak self] (response) in
                    logger.debug(response)
                    self?.state.isLoading = false
                    self?.state.log = response
                })
                .start()
        }
    }

    func route(from: UIViewController, event: BitriseDetailScene.Transition.Event) {
    }
}
