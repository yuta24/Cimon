//
//  TravisCIAPI.swift
//  App
//
//  Created by Yu Tawata on 2019/07/06.
//

import Foundation
import Common
import TravisCIAPI
import Core

extension TravisCIAPI.Standard.Build: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    public static func == (lhs: Standard.Build, rhs: Standard.Build) -> Bool {
        return lhs.id == rhs.id
            && lhs.number == rhs.number
            && lhs.state == rhs.state
            && lhs.duration == rhs.duration
            && lhs.eventType == rhs.eventType
    }
}

extension TravisCIAPI.Standard.Job: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    public static func == (lhs: Standard.Job, rhs: Standard.Job) -> Bool {
        return lhs.id == rhs.id
            && lhs.number == rhs.number
            && lhs.state == rhs.state
    }
}

extension TravisCIAPI.Standard.Build: ExtendProvider {
}

extension Extend where Base == TravisCIAPI.Standard.Build {
    enum TravisCI {
        enum Status: String {
            case passed
            case canceled
            case failed

            init?(rawValue: String) {
                switch rawValue {
                case "passed":
                    self = .passed
                case "canceled":
                    self = .canceled
                case "failed":
                    self = .failed
                default:
                    return nil
                }
            }

            var color: UIColor {
                switch self {
                case .passed:
                    return Asset.travisciStatusSuccess.color
                case .canceled:
                    return Asset.travisciStatusAborted.color
                case .failed:
                    return Asset.travisciStatusFailed.color
                }
            }
        }
    }

    var status: TravisCI.Status? {
        return TravisCI.Status(rawValue: base.state)
    }
}
