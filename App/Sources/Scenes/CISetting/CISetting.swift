//
//  CISetting.swift
//  App
//
//  Created by Yu Tawata on 2019/07/20.
//

import Foundation
import Combine
import Domain
import Core

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
  struct Context {
    var ci: CI
  }

  private(set) var state: CISettingScene.State = .initial {
    didSet {
      DispatchQueue.main.async {
        self.closure?(self.state)
      }
    }
  }

  private var closure: ((CISettingScene.State) -> Void)?

  private let dependency: CISettingScene.Dependency
  private var cancellables = [AnyCancellable]()

    init(_ context: Context, dependency: CISettingScene.Dependency) {
        self.state = .init(isLoading: false, ci: context.ci)
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
              .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .failure(let error):
                  logger.debug(error)
                  self?.state.isLoading = false
                case .finished:
                  break
                }
              }, receiveValue: { [weak self] value in
                logger.debug(value)
                self?.state.name = value.name
                self?.state.avatarUrl = value.avatarUrl
                self?.state.isLoading = false
              })
              .store(in: &cancellables)
        case .authorize(let token):
            let ci = state.ci!
            dependency.interactor.authorize(ci, token: token)
              .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .failure(let error):
                  logger.debug(error)
                  self?.state.isLoading = false
                case .finished:
                  break
                }
              }, receiveValue: { [weak self] value in
                logger.debug(value)
                self?.state.token = self?.dependency.interactor.fetchToken(ci)
                self?.state.name = value.name
                self?.state.avatarUrl = value.avatarUrl
                self?.state.isLoading = false
              })
              .store(in: &cancellables)
        case .deauthorize:
          dependency.interactor.deauthorize(state.ci)
            .sink(receiveValue: { [weak self] _ in
              self?.state.name = nil
              self?.state.avatarUrl = nil
              self?.state.token = nil
            })
            .store(in: &cancellables)
        }
    }

    func route(from: UIViewController, event: CISettingScene.Transition.Event) {
    }
}
