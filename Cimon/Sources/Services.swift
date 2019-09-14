//
//  Services.swift
//  Cimon
//
//  Created by Yu Tawata on 2019/05/14.
//

import Foundation
import APIKit
import Domain
import Core
import App

private let travisCIKindProvider: () -> AuthorizationPlugin.Kind? = {
    return store.value(.travisCIToken)
        .flatMap({ .customize(prefix: "token", token: $0.value) })
}

private let circleCIKindProvider: () -> AuthorizationPlugin.Kind? = {
    return store.value(.circleCIToken)
        .flatMap({ .basic(userName: $0.value, password: "")  })
}

private let bitriseKindProvider: () -> AuthorizationPlugin.Kind? = {
    return store.value(.bitriseToken)
        .flatMap({ .customize(prefix: .none, token: $0.value) })
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
