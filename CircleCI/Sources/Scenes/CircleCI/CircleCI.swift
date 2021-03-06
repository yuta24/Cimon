//
//  CircleCI.swift
//  App
//
//  Created by Yu Tawata on 2019/05/04.
//

import Foundation
import Combine
import CircleCIAPI
import Domain
import Core

public enum CircleCIScene {
  public struct State {
    static var initial: State {
      return .init(isLoading: false, token: .none, builds: [], offset: 0)
    }

    var isLoading: Bool
    var token: CircleCIToken?
    var builds: [Build]
    var offset: Int?

    var isUnregistered: Bool {
      return token == nil
    }
  }

  public struct Dependency {
    public var fetchUseCase: FetchBuildsFromCircleCIProtocol
    public var store: StoreProtocol

    public init(
      fetchUseCase: FetchBuildsFromCircleCIProtocol,
      store: StoreProtocol) {
        self.fetchUseCase = fetchUseCase
        self.store = store
    }
  }

  public enum Message {
    case load
    case fetch
    case fetchNext
    case token(String?)
  }
}

public protocol CircleCIViewPresenterProtocol {
  var state: CircleCIScene.State { get }

  func subscribe(_ closure: @escaping (CircleCIScene.State) -> Void)
  func unsubscribe()
  func dispatch(_ message: CircleCIScene.Message)
}

public class CircleCIViewPresenter: CircleCIViewPresenterProtocol {
  public private(set) var state: CircleCIScene.State = .initial {
    didSet {
      DispatchQueue.main.async {
        self.closure?(self.state)
      }
    }
  }

  private var closure: ((CircleCIScene.State) -> Void)?

  private let dependency: CircleCIScene.Dependency
  private var cancellables = [AnyCancellable]()

  public init(dependency: CircleCIScene.Dependency) {
    self.dependency = dependency
  }

  public func subscribe(_ closure: @escaping (CircleCIScene.State) -> Void) {
    self.closure = closure
    closure(state)
  }

  public func unsubscribe() {
    self.closure = nil
  }

  public func dispatch(_ message: CircleCIScene.Message) {
    switch message {
    case .load:
      dependency.store.value(.circleCIToken, { [weak self] (value) in
        self?.state.token = value
      })
    case .fetch:
      guard !state.isLoading else {
        return
      }
      state.isLoading = true
      dependency.fetchUseCase.run(limit: 25, offset: 0, shallow: false)
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
          self?.state.builds = value
          self?.state.offset = self?.state.builds.count
          self?.state.isLoading = false
        })
        .store(in: &cancellables)
    case .fetchNext:
      guard !state.isLoading else {
        return
      }
      guard let offset = state.offset else {
        return
      }
      state.isLoading = true
      dependency.fetchUseCase.run(limit: 25, offset: offset, shallow: false)
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
          self?.state.builds.append(contentsOf: value)
          self?.state.offset = value.isEmpty ? nil : self?.state.builds.count
          self?.state.isLoading = false
        })
        .store(in: &cancellables)
    case .token(let raw):
      let token = raw.flatMap(CircleCIToken.init)
      dependency.store.set(token, for: .circleCIToken)
      state.token = token
    }
  }
}
