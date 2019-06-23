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

let logger = LightLogger.self
let store = LocalStore(userDefaults: .standard)
let reporter = CrashlyticsReporter()

let app = App(
    window: UIWindow(frame: UIScreen.main.bounds),
    store: store,
    reporter: reporter,
    services: [
        .travisci: travisCIService,
        .circleci: circleCIService,
        .bitrise: bitriseService])
