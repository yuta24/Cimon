//
//  FirebaseAnalyticsServiceProvider.swift
//  Cimon
//
//  Created by tawata-yu on 2019/09/17.
//

import Foundation
import Shared
import FirebaseAnalytics

class FirebaseAnalyticsServiceProvider: AnalyticsServiceProviderProtocol {
    func log(_ name: String, parameter: [String: Any]?) {
        Analytics.logEvent(name, parameters: parameter)
    }
}
