//
//  Analytics.swift
//  Shared
//
//  Created by tawata-yu on 2019/09/17.
//

import Foundation

public protocol AnalyticsServiceProviderProtocol {
    func log(_ name: String, parameter: [String: Any]?)
}

public protocol AnalyticsEventProtocol {
    func isEnabled(_ provider: AnalyticsServiceProviderProtocol) -> Bool
    func name(_ provider: AnalyticsServiceProviderProtocol) -> String
    func parameter(_ provider: AnalyticsServiceProviderProtocol) -> [String: Any]?
}

public class Analytics<Event> where Event: AnalyticsEventProtocol {
    private var providers = [AnalyticsServiceProviderProtocol]()

    public init() {
    }

    public func configure(_ providers: [AnalyticsServiceProviderProtocol]) {
        self.providers = providers
    }

    public func log(event: Event) {
        providers.filter({ event.isEnabled($0) })
            .forEach { (provider) in
                provider.log(event.name(provider), parameter: event.parameter(provider))
            }
    }
}
