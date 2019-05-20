//
//  Services.swift
//  Cimon
//
//  Created by Yu Tawata on 2019/05/14.
//

import Foundation
import APIKit
import App

private let travisCIKindProvider: () -> AuthorizationPlugin.Kind? = {
    var token: String?

    let semaphore = DispatchSemaphore(value: 0)
    app.environment.store.value(.travisCIToken) { (_token) in
        token = _token?.value
        semaphore.signal()
    }
    semaphore.wait()

    return token.flatMap({ .customize(prefix: "token", token: $0) })
}

private let circleCIKindProvider: () -> AuthorizationPlugin.Kind? = {
    var token: String?

    let semaphore = DispatchSemaphore(value: 0)
    app.environment.store.value(.circleCIToken) { (_token) in
        token = _token?.value
        semaphore.signal()
    }
    semaphore.wait()

    return token.flatMap({ .basic(userName: $0, password: "") })
}

private let bitriseKindProvider: () -> AuthorizationPlugin.Kind? = {
    var token: String?

    let semaphore = DispatchSemaphore(value: 0)
    app.environment.store.value(.bitriseToken) { (_token) in
        token = _token?.value
        semaphore.signal()
    }
    semaphore.wait()

    return token.flatMap({ .customize(prefix: .none, token: $0) })
}

let travisCIService = NetworkService(
    session: Session.shared,
    plugins: [
        LoggerPlugin(outputProvider: { logger.debug($0) }),
        AuthorizationPlugin(kindProvider: travisCIKindProvider)
    ])

let circleCIService = NetworkService(
    session: Session.shared,
    plugins: [
        LoggerPlugin(outputProvider: { logger.debug($0) }),
        AuthorizationPlugin(kindProvider: circleCIKindProvider)
    ])

let bitriseService = NetworkService(
    session: Session.shared,
    plugins: [
        LoggerPlugin(outputProvider: { logger.debug($0) }),
        AuthorizationPlugin(kindProvider: bitriseKindProvider)
    ])
