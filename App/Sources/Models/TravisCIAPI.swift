//
//  TravisCIAPI.swift
//  App
//
//  Created by Yu Tawata on 2019/07/06.
//

import Foundation
import TravisCIAPI
import Shared

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

extension TravisCIAPI.Build: ExtendProvider {
}

extension Extend where Base == TravisCIAPI.Build {
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
