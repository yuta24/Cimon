//
//  CISettingInteractor.swift
//  App
//
//  Created by Yu Tawata on 2019/07/24.
//

import Foundation
import Combine
import Mocha
import Domain

protocol CISettingInteractorProtocol {
  func fetchToken(_ ci: CI) -> String?
  func fetchMe(_ ci: CI) -> AnyPublisher<(name: String?, avatarUrl: URL?), Client.Failure>
  func authorize(_ ci: CI, token: String) -> AnyPublisher<(name: String?, avatarUrl: URL?), Client.Failure>
  func deauthorize(_ ci: CI) -> AnyPublisher<Void, Never>
}

class CISettingInteractor: CISettingInteractorProtocol {
  private let store: StoreProtocol
  private let fetchMeTravisCI: FetchMeFromTravisCIProtocol
  private let fetchMeCircleCI: FetchMeFromCircleCIProtocol
  private let fetchMeBitrise: FetchMeFromBitriseProtocol

  init(
      store: StoreProtocol,

      fetchMeTravisCI: FetchMeFromTravisCIProtocol,
      fetchMeCircleCI: FetchMeFromCircleCIProtocol,
      fetchMeBitrise: FetchMeFromBitriseProtocol
  ) {
    self.store = store
    self.fetchMeTravisCI = fetchMeTravisCI
    self.fetchMeCircleCI = fetchMeCircleCI
    self.fetchMeBitrise = fetchMeBitrise
  }

  func fetchToken(_ ci: CI) -> String? {
    switch ci {
    case .travisci:
      return store.value(.travisCIToken)?.value
    case .circleci:
      return store.value(.circleCIToken)?.value
    case .bitrise:
      return store.value(.bitriseToken)?.value
    }
  }

  func fetchMe(_ ci: CI) -> AnyPublisher<(name: String?, avatarUrl: URL?), Client.Failure> {
    switch ci {
    case .travisci:
      return fetchMeTravisCI.run()
        .map { (response) in
          return (response.name, URL(string: response.avatarUrlString))
        }
        .eraseToAnyPublisher()
    case .circleci:
      return fetchMeCircleCI.run()
        .map { (response) in
          return (response.name, URL(string: response.avatarUrlString))
        }
        .eraseToAnyPublisher()
    case .bitrise:
      return fetchMeBitrise.run()
        .map { (response) in
          return (response.data?.username, response.data?.avatarUrlString.flatMap(URL.init))
        }
        .eraseToAnyPublisher()
    }
  }

  func authorize(_ ci: CI, token: String) -> AnyPublisher<(name: String?, avatarUrl: URL?), Client.Failure> {
    return Deferred { [weak self] () -> Empty<Void, Client.Failure> in
      switch ci {
      case .travisci:
            self?.store.set(TravisCIToken(token: token), for: .travisCIToken)
      case .circleci:
            self?.store.set(CircleCIToken(token: token), for: .circleCIToken)
      case .bitrise:
            self?.store.set(BitriseToken(token: token), for: .bitriseToken)
      }

      return Empty<Void, Client.Failure>()
    }
    .flatMap { [unowned self] _ in
      self.fetchMe(ci)
    }
    .eraseToAnyPublisher()
  }

  func deauthorize(_ ci: CI) -> AnyPublisher<Void, Never> {
    return Deferred { [weak self] () -> Just<Void> in
      switch ci {
      case .travisci:
          self?.store.set(nil, for: .travisCIToken)
      case .circleci:
          self?.store.set(nil, for: .circleCIToken)
      case .bitrise:
          self?.store.set(nil, for: .bitriseToken)
      }

      return Just(())
    }
    .eraseToAnyPublisher()
  }
}
