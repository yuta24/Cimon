//
//  Build.swift
//  TravisCIAPI
//
//  Created by Yu Tawata on 2019/05/05.
//

import Foundation

extension Minimal {
    // sourcery: public-initializer
    public struct Build: Codable {
        enum CodingKeys: String, CodingKey {
            case id = "id"
            case number = "number"
            case state = "state"
            case duration = "duration"
            case eventType = "event_type"
            case previousState = "previous_state"
            case pullRequestTitle = "pull_request_title"
            case pullRequestNumber = "pull_request_number"
            case startedAt = "started_at"
            case finishedAt = "finished_at"
            case `private` = "private"
        }

        public let id: Int
        public var number: String
        public var state: String
        public var duration: Int
        public var eventType: String
        public var previousState: String?
        public var pullRequestTitle: String?
        public var pullRequestNumber: Int?
        public var startedAt: String?
        public var finishedAt: String
        public var `private`: Bool

        // sourcery:inline:Minimal.Build.Init
        // swiftlint:disable line_length
        public init(id: Int, number: String, state: String, duration: Int, eventType: String, previousState: String?, pullRequestTitle: String?, pullRequestNumber: Int?, startedAt: String?, finishedAt: String, `private`: Bool) {
            self.id = id
            self.number = number
            self.state = state
            self.duration = duration
            self.eventType = eventType
            self.previousState = previousState
            self.pullRequestTitle = pullRequestTitle
            self.pullRequestNumber = pullRequestNumber
            self.startedAt = startedAt
            self.finishedAt = finishedAt
            self.`private` = `private`

        }
        // swiftlint:enabled line_length
        // sourcery:end
    }
}

extension Standard {
    // sourcery: public-initializer
    public struct Build: Codable {
        enum CodingKeys: String, CodingKey {
            case id = "id"
            case number = "number"
            case state = "state"
            case duration = "duration"
            case eventType = "event_type"
            case previousState = "previous_state"
            case pullRequestTitle = "pull_request_title"
            case pullRequestNumber = "pull_request_number"
            case startedAt = "started_at"
            case finishedAt = "finished_at"
            case `private` = "private"
            case repository = "repository"
            case branch = "branch"
            case commit = "commit"
            case jobs = "jobs"
//            case stages = "stages"
            case createdBy = "created_by"
            case updatedAt = "updated_at"
        }

        public let id: Int
        public var number: String
        public var state: String
        public var duration: Int
        public var eventType: String
        public var previousState: String?
        public var pullRequestTitle: String?
        public var pullRequestNumber: Int?
        public var startedAt: String?
        public var finishedAt: String
        public var `private`: Bool
        public var repository: Minimal.Repository?
        public var branch: Minimal.Branch?
        public var tag: Minimal.Tag?
        public var commit: Minimal.Commit?
        public var jobs: [Minimal.Job]
//        public var stages: [Stage]
        public var createdBy: Minimal.Owner?
        public var updatedAt: String?

        // sourcery:inline:Standard.Build.Init
        // swiftlint:disable line_length
        public init(id: Int, number: String, state: String, duration: Int, eventType: String, previousState: String?, pullRequestTitle: String?, pullRequestNumber: Int?, startedAt: String?, finishedAt: String, `private`: Bool, repository: Minimal.Repository?, branch: Minimal.Branch?, tag: Minimal.Tag?, commit: Minimal.Commit?, jobs: [Minimal.Job], createdBy: Minimal.Owner?, updatedAt: String?) {
            self.id = id
            self.number = number
            self.state = state
            self.duration = duration
            self.eventType = eventType
            self.previousState = previousState
            self.pullRequestTitle = pullRequestTitle
            self.pullRequestNumber = pullRequestNumber
            self.startedAt = startedAt
            self.finishedAt = finishedAt
            self.`private` = `private`
            self.repository = repository
            self.branch = branch
            self.tag = tag
            self.commit = commit
            self.jobs = jobs
            self.createdBy = createdBy
            self.updatedAt = updatedAt

        }
        // swiftlint:enabled line_length
        // sourcery:end
    }
}
