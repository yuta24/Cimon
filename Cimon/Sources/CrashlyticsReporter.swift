//
//  CrashlyticsReporter.swift
//  Cimon
//
//  Created by Yu Tawata on 2019/06/19.
//

import Foundation
import Domain
import Crashlytics

class CrashlyticsReporter: ReporterProtocol {
    func report(_ error: Error, with additionalUserInfo: [String: Any]?) {
        Crashlytics.sharedInstance().recordError(error, withAdditionalUserInfo: additionalUserInfo)
    }
}
