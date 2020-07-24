//
//  Formatter.swift
//  Core
//
//  Created by Yu Tawata on 2020/07/10.
//

import Foundation

extension Formatter {
    public static let iso8601 = ISO8601DateFormatter()
    public static let hhmmss: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .abbreviated
        formatter.allowedUnits = [.hour, .minute, .second]
        return formatter
    }()
    public static let yMdHms: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "yMdHms", options: 0, locale: .autoupdatingCurrent)
        return formatter
    }()
}
