//
//  Global.swift
//  Cimon
//
//  Created by Yu Tawata on 2019/06/23.
//

import UIKit
import Common
import Core
import App

func configure() {
    analytics.configure([FirebaseAnalyticsServiceProvider()])

    UIButton.appearance().isExclusiveTouch = true

    UINavigationBar.appearance().tintColor = .white
    UINavigationBar.appearance().barTintColor = Asset.primary.color
    UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.white]
}

let store = LocalStore(userDefaults: .standard)
let reporter = CrashlyticsReporter()

let environment = Environment(
    store: store,
    clients: [
        .travisci: travisCIClient,
        .circleci: circleCIClient,
        .bitrise: bitriseClient
    ],
    reporter: reporter)

let app = process(
    App(environment: environment),
    pre: {
        configure()
    })
