//
//  Bitrise.swift
//  App
//
//  Created by Yu Tawata on 2019/05/04.
//

import UIKit
import Combine
import BitriseAPI
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

  public struct Dependency {
    public var fetchUseCase: FetchBuildsFromBitriseProtocol
    public var store: StoreProtocol

    public init(
      fetchUseCase: FetchBuildsFromBitriseProtocol,
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

public protocol BitriseViewPresenterProtocol {
  var state: BitriseScene.State { get }

  func subscribe(_ closure: @escaping (BitriseScene.State) -> Void)
  func unsubscribe()
  func dispatch(_ message: BitriseScene.Message)
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

  private let dependency: BitriseScene.Dependency
  private var cancellables = [AnyCancellable]()

  public init(dependency: BitriseScene.Dependency) {
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
          if let data = value.data {
              self?.state.builds = data
          }
          self?.state.next = value.paging?.next
          self?.state.isLoading = false
        })
        .store(in: &cancellables)
    case .fetchNext:
      guard !state.isLoading else {
        return
      }
      guard let next = state.next else {
        return
      }
      state.isLoading = true
      dependency.fetchUseCase.run(ownerSlug: .none, isOnHold: .none, status: .none, next: next, limit: 25)
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
          if let data = value.data {
              self?.state.builds.append(contentsOf: data)
          }
          self?.state.next = value.paging?.next
          self?.state.isLoading = false
        })
        .store(in: &cancellables)
    case .token(let raw):
      let token = raw.flatMap(BitriseToken.init)
      dependency.store.set(token, for: .bitriseToken)
      state.token = token
    }
  }
}
