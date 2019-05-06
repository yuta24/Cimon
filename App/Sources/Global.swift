//
//  Global.swift
//  App
//
//  Created by Yu Tawata on 2019/05/04.
//

import Foundation
import APIKit
import Promises
import Shared

let logger = LightLogger.self

private let travisCITokenProvider: () -> String? = {
    var token: String?

    let semaphore = DispatchSemaphore(value: 0)
    App.shared.environment.storage.value(.travisCIToken) { (_token) in
        token = _token?.value
        semaphore.signal()
    }
    semaphore.wait()

    return token
}

private let circleCITokenProvider: () -> String? = {
    var token: String?

    let semaphore = DispatchSemaphore(value: 0)
    App.shared.environment.storage.value(.circleCIToken) { (_token) in
        token = _token?.value
        semaphore.signal()
    }
    semaphore.wait()

    return token
}

private let bitriseTokenProvider: () -> String? = {
    var token: String?

    let semaphore = DispatchSemaphore(value: 0)
    App.shared.environment.storage.value(.bitriseToken) { (_token) in
        token = _token?.value
        semaphore.signal()
    }
    semaphore.wait()

    return token
}

let travisCIService = NetworkService(
    session: Session.shared,
    plugins: [
        LoggerPlugin(outputProvider: { logger.debug($0) }),
        AuthorizationPlugin(kind: .customize("token"), tokenProvider: travisCITokenProvider)
    ])

let circleCIService = NetworkService(
    session: Session.shared,
    plugins: [
        LoggerPlugin(outputProvider: { logger.debug($0) }),
        AuthorizationPlugin(kind: .customize("token"), tokenProvider: circleCITokenProvider)
    ])

let bitriseService = NetworkService(
    session: Session.shared,
    plugins: [
        LoggerPlugin(outputProvider: { logger.debug($0) }),
        AuthorizationPlugin(kind: .customize("token"), tokenProvider: bitriseTokenProvider)
    ])
