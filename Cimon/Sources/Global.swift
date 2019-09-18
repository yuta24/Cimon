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

let store = LocalStore(userDefaults: .standard)
let reporter = CrashlyticsReporter()

let environment = Environment(
    store: store,
    networks: [
        .travisci: travisCIService,
        .circleci: circleCIService,
        .bitrise: bitriseService],
    reporter: reporter)

let app = process(
    App(environment: environment),
    pre: {
        configure()
    })
