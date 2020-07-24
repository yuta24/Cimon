//
//  Bitrise.swift
//  Cimon
//
//  Created by Yu Tawata on 2020/07/10.
//

import Foundation
import Common
import BitriseAPI
import Core

extension BitriseAPI.BuildListAllResponseItemModel: ExtendProvider {
}

extension Extend where Base == BitriseAPI.BuildListAllResponseItemModel {
    enum Bitrise {
        enum Status: String {
            case success
            case aborted
            case error
            case inprogress

            init?(rawValue: String) {
                switch rawValue {
                case "success":
                  self = .success
                case "aborted":
                  self = .aborted
                case "error":
                  self = .error
                case "in-progress":
                    self = .inprogress
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
                case .inprogress:
                    return Asset.bitriseStatusProgress.color
                }
            }

            var isInprogress: Bool {
                if case .inprogress = self {
                    return true
                } else {
                    return false
                }
            }
        }
    }

    var status: Bitrise.Status? {
        return base.statusText.flatMap(Bitrise.Status.init)
    }
}

extension BitriseAPI.BuildListAllResponseItemModel {
    public var duration: TimeInterval? {
        if let startedAt = startedOnWorkerAt.flatMap(Formatter.iso8601.date(from:)),
           let finishedAt = finishedAt.flatMap(Formatter.iso8601.date(from:)) {
            return finishedAt.timeIntervalSince1970 - startedAt.timeIntervalSince1970
        } else {
            return .none
        }
    }
}
