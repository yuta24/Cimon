//
//  CISetting.swift
//  App
//
//  Created by Yu Tawata on 2019/07/20.
//

import Foundation
import Shared
import Domain

enum CISettingScene {
    struct State {
        var isLoading: Bool
        let ci: CI!
        var token: String?
        var name: String?
        var avatarUrl: URL?

        var authorized: Bool {
            return !token.isNil
        }

        static var initial: State {
            return .init(
                isLoading: false,
                ci: .none,
                token: .none,
                name: .none,
                avatarUrl: .none)
        }
    }

    enum Message {
        case load
        case authorize(String)
        case deauthorize
    }

    struct Dependency {
        var interactor: CISettingInteractorProtocol
    }

    enum Transition {
        enum Event {
        }
    }
}

protocol CISettingViewPresenterProtocol {
    var state: CISettingScene.State { get }

    func subscribe(_ closure: @escaping (CISettingScene.State) -> Void)
    func unsubscribe()
    func dispatch(_ message: CISettingScene.Message)

    func route(from: UIViewController, event: CISettingScene.Transition.Event)
}

class CISettingViewPresenter: CISettingViewPresenterProtocol {
    private(set) var state: CISettingScene.State = .initial {
        didSet {
            DispatchQueue.main.async {
                self.closure?(self.state)
            }
        }
    }

    private var closure: ((CISettingScene.State) -> Void)?

    private let dependency: CISettingScene.Dependency

    init(ci: CI, dependency: CISettingScene.Dependency) {
        self.state = .init(isLoading: false, ci: ci)
        self.dependency = dependency
    }

    func subscribe(_ closure: @escaping (CISettingScene.State) -> Void) {
        self.closure = closure
        closure(state)
    }

    func unsubscribe() {
        self.closure = nil
    }

    func dispatch(_ message: CISettingScene.Message) {
        switch message {
        case .load:
            guard !state.isLoading else {
                return
            }
            state.isLoading = true
            state.token = dependency.interactor.fetchToken(state.ci)
            dependency.interactor.fetchMe(state.ci)
                .on(failed: { [weak self] (error) in
                    logger.debug(error)
                    self?.state.isLoading = false
                }, value: { [weak self] (response) in
                    logger.debug(response)
                    self?.state.name = response.name
                    self?.state.avatarUrl = response.avatarUrl
                    self?.state.isLoading = false
                })
                .start()
        case .authorize(let token):
            let ci = state.ci!
            dependency.interactor.authorize(ci, token: token)
                .on(failed: { [weak self] (error) in
                    logger.debug(error)
                    self?.state.isLoading = false
                }, value: { [weak self] (response) in
                    logger.debug(response)
                    self?.state.token = self?.dependency.interactor.fetchToken(ci)
                    self?.state.name = response.name
                    self?.state.avatarUrl = response.avatarUrl
                    self?.state.isLoading = false
                })
                .start()
        case .deauthorize:
            dependency.interactor.deauthorize(state.ci)
                .start()
            state.name = nil
            state.avatarUrl = nil
            state.token = dependency.interactor.fetchToken(state.ci)
        }
    }

    func route(from: UIViewController, event: CISettingScene.Transition.Event) {
    }
}
