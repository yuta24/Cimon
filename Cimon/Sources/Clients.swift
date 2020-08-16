//
//  Clients.swift
//  Cimon
//
//  Created by Yu Tawata on 2019/05/14.
//

import Foundation
import Mocha
import Common
import Domain
import Core

struct AuthorizationInterceptor: Interceptor {
  public enum Kind {
      case basic(userName: String, password: String)
      case bearer(token: String)
      case customize(prefix: String?, token: String)
  }

  let kindProvider: () -> Kind?

  public init(kindProvider: @escaping () -> Kind?) {
    self.kindProvider = kindProvider
  }

  func request(_ request: URLRequest) -> URLRequest {
      var request = request

      switch kindProvider() {
      case .some(.basic(let userName, let password)):
        if let token = "\(userName):\(password)".data(using: .utf8)?.base64EncodedString() {
          request.addValue("Basic \(token)", forHTTPHeaderField: "Authorization")
        }
      case .some(.bearer(let token)):
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
      case .some(.customize(let prefix, let token)):
        if let prefix = prefix {
          request.addValue("\(prefix) \(token)", forHTTPHeaderField: "Authorization")
        } else {
          request.addValue("\(token)", forHTTPHeaderField: "Authorization")
        }
      case .none:
          break
      }

      return request
  }

  func response(_ request: URLRequest, data: Data?, response: URLResponse?, error: Error?) {
    // no operation.
  }
}

private let travisCIKindProvider: () -> AuthorizationInterceptor.Kind? = {
    return storage.value(.travisCIToken)
        .flatMap({ .customize(prefix: "token", token: $0.value) })
}

private let circleCIKindProvider: () -> AuthorizationInterceptor.Kind? = {
    return storage.value(.circleCIToken)
        .flatMap({ .basic(userName: $0.value, password: "")  })
}

private let bitriseKindProvider: () -> AuthorizationInterceptor.Kind? = {
    return storage.value(.bitriseToken)
        .flatMap({ .customize(prefix: .none, token: $0.value) })
}

let travisCIClient =  Client({
    let network = Network(session: .shared)
    network.interceptors.append(AuthorizationInterceptor(kindProvider: travisCIKindProvider))
    return network
  }(),
  with: URL(string: "https://api.travis-ci.org")!)

let circleCIClient = Client({
    let network = Network(session: .shared)
    network.interceptors.append(AuthorizationInterceptor(kindProvider: circleCIKindProvider))
    return network
  }(),
  with: URL(string: "https://circleci.com/api/v1.1")!)

let bitriseClient = Client({
    let network = Network(session: .shared)
    network.interceptors.append(AuthorizationInterceptor(kindProvider: bitriseKindProvider))
    return network
  }(),
  with: URL(string: "https://api.bitrise.io/v0.1")!)
