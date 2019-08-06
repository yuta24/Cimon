//
//  Build.swift
//  TravisCIAPI
//
//  Created by Yu Tawata on 2019/05/05.
//

import Foundation

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
    }

    // @minimal
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

    public var repository: Repository?
    public var branch: Branch?
    public var tag: Tag?
    public var commit: Commit

    // sourcery:inline:Build.Init
    // swiftlint:disable line_length
    public init(id: Int, number: String, state: String, duration: Int, eventType: String, previousState: String?, pullRequestTitle: String?, pullRequestNumber: Int?, startedAt: String?, finishedAt: String, `private`: Bool, repository: Repository?, branch: Branch?, tag: Tag?, commit: Commit) {
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

    }
    // swiftlint:enabled line_length
    // sourcery:end
}
