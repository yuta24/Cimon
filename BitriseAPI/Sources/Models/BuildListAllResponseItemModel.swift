//
//  BuildListAllResponseItemModel.swift
//  BitriseAPI
//
//  Created by Yu Tawata on 2019/05/06.
//

import Foundation

public struct BuildListAllResponseItemModel: Codable {
    public var abortReason: String?
    public var branch: String?
    public var buildNumber: Int?
    public var commitHash: String?
    public var commitMessage: String?
    public var commitViewUrl: String?
    public var environmentPrepareFinishedAt: String?
    public var finishedAt: String?
    public var isOnHold: Bool?
//    public var originalBuildParams: String?
    public var pullRequestId: Int?
    public var pullRequestTargetBranch: String?
    public var pullRequestViewUrl: String?
    public var repository: AppResponseItemModel?
    public var slug: String?
    public var stackConfigType: String?
    public var stackIdentifier: String?
    public var startedOnWorkerAt: String?
    public var status: Int?
    public var statusText: String?
    public var tag: String?
    public var triggeredAt: String?
    public var triggeredBy: String?
    public var triggeredWorkflow: String?

    public init(
        abortReason: String?,
        branch: String?,
        buildNumber: Int?,
        commitHash: String?,
        commitMessage: String?,
        commitViewUrl: String?,
        environmentPrepareFinishedAt: String?,
        finishedAt: String?,
        isOnHold: Bool?,
        pullRequestId: Int?,
        pullRequestTargetBranch: String?,
        pullRequestViewUrl: String?,
        repository: AppResponseItemModel?,
        slug: String?,
        stackConfigType: String?,
        stackIdentifier: String?,
        startedOnWorkerAt: String?,
        status: Int?,
        statusText: String?,
        tag: String?,
        triggeredAt: String?,
        triggeredBy: String?,
        triggeredWorkflow: String?
    ) {
        self.abortReason = abortReason
        self.branch = branch
        self.buildNumber = buildNumber
        self.commitHash = commitHash
        self.commitMessage = commitMessage
        self.commitViewUrl = commitViewUrl
        self.environmentPrepareFinishedAt = environmentPrepareFinishedAt
        self.finishedAt = finishedAt
        self.isOnHold = isOnHold
        self.pullRequestId = pullRequestId
        self.pullRequestTargetBranch = pullRequestTargetBranch
        self.pullRequestViewUrl = pullRequestViewUrl
        self.repository = repository
        self.slug = slug
        self.stackConfigType = stackConfigType
        self.stackIdentifier = stackIdentifier
        self.startedOnWorkerAt = startedOnWorkerAt
        self.status = status
        self.statusText = statusText
        self.tag = tag
        self.triggeredAt = triggeredAt
        self.triggeredBy = triggeredBy
        self.triggeredWorkflow = triggeredWorkflow
    }
}

extension BuildListAllResponseItemModel: Equatable, Hashable {
    public func hash(into hasher: inout Hasher) {
      hasher.combine(buildNumber!)
    }
}
