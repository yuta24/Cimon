//
//  BitriseDetail.swift
//  App
//
//  Created by Yu Tawata on 2019/07/01.
//

import Foundation
import Combine
import BitriseAPI
import Mocha
import Domain
import Core

public enum BitriseDetailScene {
  public struct State {
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

  public struct Dependency {
    public var store: StoreProtocol
    public var client: Client

    public init(
      store: StoreProtocol,
      client: Client
    ) {
      self.store = store
      self.client = client
    }
  }

  public enum Message {
    case fetch
  }
}

public protocol BitriseDetailViewPresenterProtocol {
  var state: BitriseDetailScene.State { get }

  func subscribe(_ closure: @escaping (BitriseDetailScene.State) -> Void)
  func unsubscribe()
  func dispatch(_ message: BitriseDetailScene.Message)

  func route(from: UIViewController, event: BitriseDetail.Transition.Event)
}

public class BitriseDetailViewPresenter: BitriseDetailViewPresenterProtocol {
  public struct Context {
    public var appSlug: String
    public var buildSlug: String

    public init(
      appSlug: String,
      buildSlug: String) {
        self.appSlug = appSlug
        self.buildSlug = buildSlug
    }
  }

  public private(set) var state: BitriseDetailScene.State = .initial {
    didSet {
      DispatchQueue.main.async {
        self.closure?(self.state)
      }
    }
  }

  private var closure: ((BitriseDetailScene.State) -> Void)?
  private let context: Context

  private let dependency: BitriseDetailScene.Dependency
  private var cancellables = [AnyCancellable]()

  public init(_ context: Context, dependency: BitriseDetailScene.Dependency) {
    self.context = context
    self.dependency = dependency
  }

  public func subscribe(_ closure: @escaping (BitriseDetailScene.State) -> Void) {
    self.closure = closure
    closure(state)
  }

  public func unsubscribe() {
    self.closure = nil
  }

  public func dispatch(_ message: BitriseDetailScene.Message) {
    switch message {
    case .fetch:
      guard !state.isLoading else {
        return
      }

      state.isLoading = true
      dependency.client.publisher(for: Endpoint.BuildLogRequest(appSlug: self.context.appSlug, buildSlug: self.context.buildSlug))
        .sink(receiveCompletion: { [weak self] completion in
          self?.state.isLoading = false
          switch completion {
          case .failure(let error):
            logger.debug(error)
          case .finished:
            break
          }
        }, receiveValue: { [weak self] value in
          logger.debug(value)
          self?.state.isLoading = false
          self?.state.log = value
        })
        .store(in: &cancellables)
    }
  }

  public func route(from: UIViewController, event: BitriseDetail.Transition.Event) {
  }
}
