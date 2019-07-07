//
//  BitriseAPI.swift
//  App
//
//  Created by Yu Tawata on 2019/07/06.
//

import Foundation
import BitriseAPI
import Shared

extension BitriseAPI.BuildListAllResponseItemModel: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(buildNumber ?? 0)
    }

    public static func == (lhs: BuildListAllResponseItemModel, rhs: BuildListAllResponseItemModel) -> Bool {
        return lhs.branch == rhs.branch
            && lhs.buildNumber == rhs.buildNumber
            && lhs.commitHash == rhs.commitHash
            && lhs.pullRequestId == rhs.pullRequestId
            && lhs.slug == rhs.slug
    }
}

extension BitriseAPI.BuildListAllResponseItemModel: ExtendProvider {
}

extension Extend where Base == BitriseAPI.BuildListAllResponseItemModel {
    enum Bitrise {
        enum Status: String {
            case success
            case aborted
            case error

            init?(rawValue: String) {
                switch rawValue {
                case "success":
                    self = .success
                case "aborted":
                    self = .aborted
                case "error":
                    self = .error
                default:
                    return nil
                }
            }

            var color: UIColor {
                switch self {
                case .success:
                    return Asset.bitriseStatusSuccess.color
                case .aborted:
                    return Asset.bitriseStatusAborted.color
                case .error:
                    return Asset.bitriseStatusFailed.color
                }
            }
        }
    }

    var status: Bitrise.Status? {
        return base.statusText.flatMap(Bitrise.Status.init)
    }
}
