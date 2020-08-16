//
//  CrashlyticsReporter.swift
//  Cimon
//
//  Created by Yu Tawata on 2019/06/19.
//

import Foundation
import Core
import FirebaseCrashlytics

class CrashlyticsReporter: ReporterProtocol {
    func report(_ error: Error) {
        Crashlytics.crashlytics().record(error: error)
    }
}
