//
//  Global.swift
//  Cimon
//
//  Created by Yu Tawata on 2019/06/23.
//

import Foundation
import UIKit
import Shared
import App

func configure() {
    UIButton.appearance().isExclusiveTouch = true

    UINavigationBar.appearance().tintColor = .white
    UINavigationBar.appearance().barTintColor = Asset.primary.color
    UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.white]
}

let store = LocalStore(userDefaults: .standard)
let reporter = CrashlyticsReporter()
let sceneFactory = SceneFactory()

let app = process(
    App(
        window: UIWindow(frame: UIScreen.main.bounds),
        store: store,
        reporter: reporter,
        sceneFactory: sceneFactory,
        networks: [
            .travisci: travisCIService,
            .circleci: circleCIService,
            .bitrise: bitriseService]),
    pre: {
        configure()
    })
