//
//  TravisCI.swift
//  App
//
//  Created by Yu Tawata on 2019/05/04.
//

import Foundation
import Combine
import ReactiveSwift
import TravisCIAPI
import Shared
import Domain
import Core

public enum TravisCIScene {
  public struct State {
    static var initial: State {
      return .init(isLoading: false, token: .none, builds: [], offset: 0)
    }

    var isLoading: Bool
    var token: TravisCIToken?
    var builds: [Standard.Build]
    var offset: Int?

    var isUnregistered: Bool {
      return token == nil
    }
  }

  public struct Dependency {
    public var fetchUseCase: FetchBuildsFromTravisCIProtocol
    public var store: StoreProtocol

    public init(
      fetchUseCase: FetchBuildsFromTravisCIProtocol,
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

public protocol TravisCIViewPresenterProtocol {
  var state: TravisCIScene.State { get }

  func subscribe(_ closure: @escaping (TravisCIScene.State) -> Void)
  func unsubscribe()
  func dispatch(_ message: TravisCIScene.Message)
}

public class TravisCIViewPresenter: TravisCIViewPresenterProtocol {
  public private(set) var state: TravisCIScene.State = .initial {
    didSet {
      DispatchQueue.main.async {
        self.closure?(self.state)
      }
    }
  }

  private var closure: ((TravisCIScene.State) -> Void)?

  private let dependency: TravisCIScene.Dependency
  private var cancellables = [AnyCancellable]()

  public init(dependency: TravisCIScene.Dependency) {
    self.dependency = dependency
  }

  public func subscribe(_ closure: @escaping (TravisCIScene.State) -> Void) {
    self.closure = closure
    closure(state)
  }

  public func unsubscribe() {
    self.closure = nil
  }

  public func dispatch(_ message: TravisCIScene.Message) {
    switch message {
    case .load:
      dependency.store.value(.travisCIToken, { [weak self] (value) in
        self?.state.token = value
      })
    case .fetch:
      guard !state.isLoading else {
        return
      }
      state.isLoading = true
      dependency.fetchUseCase.run(limit: 25, offset: 0)
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
          self?.state.builds = value.builds
          self?.state.offset = value.pagination.next?.offset
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
      dependency.fetchUseCase.run(limit: 25, offset: offset)
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
          self?.state.builds.append(contentsOf: value.builds)
          self?.state.offset = value.pagination.next?.offset
          self?.state.isLoading = false
        })
        .store(in: &cancellables)
    case .token(let raw):
      let token = raw.flatMap(TravisCIToken.init)
      dependency.store.set(token, for: .travisCIToken)
      state.token = token
    }
  }
}
