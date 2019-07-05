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
            return .init(isLoading: false, token: .none)
        }

        var isLoading: Bool
        var token: BitriseToken?

        var isUnregistered: Bool {
            return token == nil
        }
    }

    enum Message {
        case fetch
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

protocol BitriseDetailViewPresenterProtocol {
    var state: BitriseDetailScene.State { get }

    func subscribe(_ closure: @escaping (BitriseDetailScene.State) -> Void)
    func unsubscribe()
    func dispatch(_ message: BitriseDetailScene.Message) -> Reader<BitriseDetailScene.Dependency, Void>

    func route(event: BitriseDetailScene.Transition.Event) -> Reader<UIViewController, Void>
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

    init(_ context: Context) {
        self.context = context
    }

    func subscribe(_ closure: @escaping (BitriseDetailScene.State) -> Void) {
        self.closure = closure
        closure(state)
    }

    func unsubscribe() {
        self.closure = nil
    }

    func dispatch(_ message: BitriseDetailScene.Message) -> Reader<BitriseDetailScene.Dependency, Void> {
        return .init({ [weak self] (dependency) in
            guard let `self` = self else {
                return
            }

            switch message {
            case .fetch:
                guard !self.state.isLoading else {
                    return
                }
                self.state.isLoading = true
                dependency.network.response(Endpoint.BuildLog(appSlug: self.context.appSlug, buildSlug: self.context.buildSlug))
                    .on(failed: { (error) in
                        logger.debug(error)
                        self.state.isLoading = false
                    }, value: { (response) in
                        logger.debug(response)
                        self.state.isLoading = false
                    })
                    .start()
            }
        })
    }

    func route(event: BitriseDetailScene.Transition.Event) -> Reader<UIViewController, Void> {
        return .init({ (from) in
        })
    }
}
