//
//  Global.swift
//  Cimon
//
//  Created by Yu Tawata on 2019/06/23.
//

import UIKit
import Common
import Core
import FirebaseCrashlytics

let storage = LocalStorage(userDefaults: .standard)
let reporter = CrashlyticsReporter(crashlytics: Crashlytics.crashlytics())
