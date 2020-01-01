//
//  CircleCIAPI.swift
//  App
//
//  Created by Yu Tawata on 2019/07/07.
//

import Common
import CircleCIAPI
import Core

extension CircleCIAPI.Build: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(buildNum)
    }

    public static func == (lhs: Build, rhs: Build) -> Bool {
        return lhs.buildNum == rhs.buildNum
            && lhs.status == rhs.status
            && lhs.buildTimeMillis == rhs.buildTimeMillis
    }
}

extension CircleCIAPI.Build: ExtendProvider {
}

extension Extend where Base == CircleCIAPI.Build {
    enum CircleCI {
        enum Status: String {
            case success
            case aborted
            case failed
            case fixed

            init?(rawValue: String) {
                switch rawValue {
                case "success":
                    self = .success
                case "aborted":
                    self = .aborted
                case "failed":
                    self = .failed
                case "fixed":
                    self = .fixed
                default:
                    return nil
                }
            }

            var color: UIColor {
                switch self {
                case .success:
                    return Asset.circleciStatusSuccess.color
                case .aborted:
                    return Asset.circleciStatusAborted.color
                case .failed:
                    return Asset.circleciStatusFailed.color
                case .fixed:
                    return Asset.circleciStatusSuccess.color
                }
            }
        }
    }

    var status: CircleCI.Status? {
        return CircleCI.Status(rawValue: base.status)
    }
}
