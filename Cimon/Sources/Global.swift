//
//  Global.swift
//  Cimon
//
//  Created by Yu Tawata on 2019/06/23.
//

import Foundation
import UIKit
import Shared
import Core
import App

func configure() {
    analytics.configure([FirebaseAnalyticsServiceProvider()])

    UIButton.appearance().isExclusiveTouch = true

    UINavigationBar.appearance().tintColor = .white
    UINavigationBar.appearance().barTintColor = Asset.primary.color
    UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.white]
}

let storage = LocalStorage(userDefaults: .standard)
let reporter = CrashlyticsReporter()

let environment = Environment(
    persistent: storage,
    networks: [
        .travisci: travisCIService,
        .circleci: circleCIService,
        .bitrise: bitriseService],
    reporter: reporter)

let app = process(
    App(
        store: Store<AppState, AppAction>(
            initial: AppState(
                travisCIToken: nil,
                circleCIToken: nil,
                bitriseToken: nil),
            reducer: appReducer),
        environment: environment),
    pre: {
        configure()
    })
