//
//  AuthorizationInterceptor.swift
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
  enum Kind {
      case basic(userName: String, password: String)
      case bearer(token: String)
      case customize(prefix: String?, token: String)
  }

  let kindProvider: () -> Kind?

  init(kindProvider: @escaping () -> Kind?) {
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
