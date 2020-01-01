//
//  Jobs.swift
//  TravisCIAPI
//
//  Created by Yu Tawata on 2019/08/11.
//

import Foundation

extension Standard {
    // sourcery: public-initializer
    public struct Jobs: Codable {
        enum CodingKeys: String, CodingKey {
            case jobs
        }

        public var jobs: [Standard.Job]

        // sourcery:inline:Standard.Jobs.Init
        // swiftlint:disable line_length
        public init(jobs: [Standard.Job]) {
            self.jobs = jobs

        }
        // swiftlint:enabled line_length
        // sourcery:end
    }
}
