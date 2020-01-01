//
//  AnalyticsEvent.swift
//  Core
//
//  Created by tawata-yu on 2019/09/17.
//

import Common

public enum AnalyticsEvent: AnalyticsEventProtocol {
    case tap(screenName: String, custom: [String: Any] = [:])
    case select(itemId: String, screenName: String, custom: [String: Any] = [:])
    case response(method: String, path: String, statusCode: Int, custom: [String: Any] = [:])

    public func isEnabled(_ provider: AnalyticsServiceProviderProtocol) -> Bool {
        return true
    }

    public func name(_ provider: AnalyticsServiceProviderProtocol) -> String {
        switch self {
        case .tap:
            return "tap"
        case .select:
            return "select"
        case .response:
            return "response"
        }
    }

    public func parameter(_ provider: AnalyticsServiceProviderProtocol) -> [String: Any]? {
        switch self {
        case .tap(let screenName, let custom):
            let params: [String: Any] = [
                "screen_name": screenName
            ]
            return params.merging(custom, uniquingKeysWith: { a, _ in a })
        case .select(let itemId, let screenName, let custom):
            let params: [String: Any] = [
                "item_id": itemId,
                "screen_name": screenName
            ]
            return params.merging(custom, uniquingKeysWith: { a, _ in a })
        case .response(let method, let path, let statusCode, let custom):
            let params: [String: Any] = [
                "method": method,
                "path": path,
                "status_code": statusCode
            ]
            return params.merging(custom, uniquingKeysWith: { a, _ in a })
        }
    }
}
