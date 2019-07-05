//
//  BuildLog.swift
//  BitriseAPI
//
//  Created by Yu Tawata on 2019/07/01.
//

import Foundation
import APIKit

public extension Endpoint {
    struct BuildLog: BitriseRequest {
        public typealias Response = BuildLogInfoResponseModel

        public enum Status: Int {
            case notFinished = 0
            case successful
            case failed
            case abortedWithFailure
            case abortedWithSuccess
        }

        public var path: String {
            return "/apps/\(appSlug)/builds/\(buildSlug)/log"
        }

        public var method: HTTPMethod {
            return .get
        }

        public var appSlug: String
        public var buildSlug: String

        public init(
            appSlug: String,
            buildSlug: String) {
            self.appSlug = appSlug
            self.buildSlug = buildSlug
        }
    }
}
