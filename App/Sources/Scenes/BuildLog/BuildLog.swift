//
//  BuildLog.swift
//  App
//
//  Created by Yu Tawata on 2019/08/11.
//

import Foundation
import ReactiveSwift
import TravisCIAPI
import Shared
import Domain

enum BuildLogScene {
    struct State {
        static var initial: State {
            return .init(isLoading: false, log: .none)
        }

        var isLoading: Bool
        var log: String?
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

protocol BuildLogViewPresenterProtocol {
    var state: BuildLogScene.State { get }

    func subscribe(_ closure: @escaping (BuildLogScene.State) -> Void)
    func unsubscribe()
    func dispatch(_ message: BuildLogScene.Message)

    func route(from: UIViewController, event: BuildLogScene.Transition.Event)
}

class BuildLogViewPresenter: BuildLogViewPresenterProtocol {
    struct Context {
        var buildId: Int
    }

    private(set) var state: BuildLogScene.State = .initial {
        didSet {
            DispatchQueue.main.async {
                self.closure?(self.state)
            }
        }
    }

    private var closure: ((BuildLogScene.State) -> Void)?

    private let context: Context
    private let dependency: BuildLogScene.Dependency

    init(_ context: Context, dependency: BuildLogScene.Dependency) {
        self.context = context
        self.dependency = dependency
    }

    func subscribe(_ closure: @escaping (BuildLogScene.State) -> Void) {
        self.closure = closure
        closure(state)
    }

    func unsubscribe() {
        self.closure = nil
    }

    func dispatch(_ message: BuildLogScene.Message) {
//        switch message {
//        case .fetch:
//            guard !state.isLoading else {
//                return
//            }
//            state.isLoading = true
//            dependency.interactor.fetchJobs(buildId: context.buildId)
//                .on(failed: { [weak self] (error) in
//                    logger.debug(error)
//                    self?.state.isLoading = false
//                }, value: { [weak self] (response) in
//                    logger.debug(response)
//                    self?.state.isLoading = false
//                    self?.state.jobs = response
//                })
//                .start()
//        }
    }

    func route(from: UIViewController, event: BuildLogScene.Transition.Event) {
    }
}
