//
//  TravisCIAPI.swift
//  App
//
//  Created by Yu Tawata on 2019/07/06.
//

import Foundation
import TravisCIAPI

extension TravisCIAPI.Build: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    public static func == (lhs: Build, rhs: Build) -> Bool {
        return lhs.id == rhs.id
            && lhs.number == rhs.number
            && lhs.state == rhs.state
            && lhs.duration == rhs.duration
            && lhs.eventType == rhs.eventType
    }
}
