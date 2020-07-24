//
//  Endpoint+BuildLog.swift
//  BitriseAPI
//
//  Created by Yu Tawata on 2019/07/01.
//

import Foundation
import Mocha

extension Endpoint {
    public struct BuildLogRequest: BitriseRequest {
        public typealias Response = BuildLogInfoResponseModel

        public enum Status: Int {
            case notFinished = 0
            case successful
            case failed
            case abortedWithFailure
            case abortedWithSuccess
        }

        public var path: String { "/apps/\(appSlug)/builds/\(buildSlug)/log" }
        public var method: HTTPMethod { .get }

        public let appSlug: String
        public let buildSlug: String

        public init(
            appSlug: String,
            buildSlug: String
        ) {
            self.appSlug = appSlug
            self.buildSlug = buildSlug
        }
    }
}
