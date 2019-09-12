//
//  Job.swift
//  TravisCIAPI
//
//  Created by Yu Tawata on 2019/08/11.
//

import Foundation
import APIKit

extension Minimal {
    // sourcery: public-initializer
    public struct Job: Codable {
        enum CodingKeys: String, CodingKey {
            case id
        }

        public var id: Int

        // sourcery:inline:Minimal.Job.Init
        // swiftlint:disable line_length
        public init(id: Int) {
            self.id = id

        }
        // swiftlint:enabled line_length
        // sourcery:end
    }
}

extension Standard {
    // sourcery: public-initializer
    public struct Job: Codable {
        enum CodingKeys: String, CodingKey {
            case id = "id"
//            case allowFailure = "allow_failure"
            case number = "number"
            case state = "state"
            case startedAt = "started_at"
            case finishedAt = "finished_at"
            case build = "build"
            case queue = "queue"
            case repository = "repository"
            case commit = "commit"
            case owner = "owner"
//            case stage = "stage"
            case createdAt = "created_at"
            case updatedAt = "updated_at"
            case `private` = "private"
        }

        public var id: Int
//        public var allowFailure: Any
        public var number: String
        public var state: String
        public var startedAt: String
        public var finishedAt: String
        public var build: Minimal.Build
        public var queue: String
        public var repository: Minimal.Repository
        public var commit: Minimal.Commit
        public var owner: Minimal.Owner
//        public var stage: [Stage]
        public var createdAt: String
        public var updatedAt: String
        public var `private`: Bool

        // sourcery:inline:Standard.Job.Init
        // swiftlint:disable line_length
        public init(id: Int, number: String, state: String, startedAt: String, finishedAt: String, build: Minimal.Build, queue: String, repository: Minimal.Repository, commit: Minimal.Commit, owner: Minimal.Owner, createdAt: String, updatedAt: String, `private`: Bool) {
            self.id = id
            self.number = number
            self.state = state
            self.startedAt = startedAt
            self.finishedAt = finishedAt
            self.build = build
            self.queue = queue
            self.repository = repository
            self.commit = commit
            self.owner = owner
            self.createdAt = createdAt
            self.updatedAt = updatedAt
            self.`private` = `private`

        }
        // swiftlint:enabled line_length
        // sourcery:end
    }
}
