//
//  CrashlyticsReporter.swift
//  Cimon
//
//  Created by Yu Tawata on 2019/06/19.
//

import Foundation
import Common
import FirebaseCrashlytics

class CrashlyticsReporter: ReporterProtocol {
    private let crashlytics: Crashlytics

    init(crashlytics: Crashlytics) {
        self.crashlytics = crashlytics
    }

    func report(_ error: Error) {
        crashlytics.record(error: error)
    }
}
