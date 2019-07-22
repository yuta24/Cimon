//
//  BuildListAllResponseItemModel.swift
//  BitriseAPI
//
//  Created by Yu Tawata on 2019/05/06.
//

import Foundation

// sourcery: public-initializer
public struct BuildListAllResponseItemModel: Codable {
    enum CodingKeys: String, CodingKey {
        case abortReason = "abort_reason"
        case branch
        case buildNumber = "build_number"
        case commitHash = "commit_hash"
        case commitMessage = "commit_message"
        case commitViewUrlString = "commit_view_url"
        case environmentPrepareFinishedAt = "environment_prepare_finished_at"
        case finishedAt = "finished_at"
        case isOnHold = "is_on_hold"
//        case originalBuildParams = "original_build_params"
        case pullRequestId = "pull_request_id"
        case pullRequestTargetBranch = "pull_request_target_branch"
        case pullRequestViewUrlString = "pull_request_view_url"
        case repository
        case slug
        case stackConfigType = "stack_config_type"
        case stackIdentifier = "stack_identifier"
        case startedOnWorkerAt = "started_on_worker_at"
        case status
        case statusText = "status_text"
        case tag
        case triggeredAt = "triggered_at"
        case triggeredBy = "triggered_by"
        case triggeredWorkflow = "triggered_workflow"
    }

    public var abortReason: String?
    public var branch: String?
    public var buildNumber: Int?
    public var commitHash: String?
    public var commitMessage: String?
    public var commitViewUrlString: String?
    public var environmentPrepareFinishedAt: String?
    public var finishedAt: String?
    public var isOnHold: Bool?
//    public var originalBuildParams: String?
    public var pullRequestId: Int?
    public var pullRequestTargetBranch: String?
    public var pullRequestViewUrlString: String?
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

    // sourcery:inline:BuildListAllResponseItemModel.Init
    // swiftlint:disable line_length
    public init(abortReason: String?, branch: String?, buildNumber: Int?, commitHash: String?, commitMessage: String?, commitViewUrlString: String?, environmentPrepareFinishedAt: String?, finishedAt: String?, isOnHold: Bool?, pullRequestId: Int?, pullRequestTargetBranch: String?, pullRequestViewUrlString: String?, repository: AppResponseItemModel?, slug: String?, stackConfigType: String?, stackIdentifier: String?, startedOnWorkerAt: String?, status: Int?, statusText: String?, tag: String?, triggeredAt: String?, triggeredBy: String?, triggeredWorkflow: String?) {
        self.abortReason = abortReason
        self.branch = branch
        self.buildNumber = buildNumber
        self.commitHash = commitHash
        self.commitMessage = commitMessage
        self.commitViewUrlString = commitViewUrlString
        self.environmentPrepareFinishedAt = environmentPrepareFinishedAt
        self.finishedAt = finishedAt
        self.isOnHold = isOnHold
        self.pullRequestId = pullRequestId
        self.pullRequestTargetBranch = pullRequestTargetBranch
        self.pullRequestViewUrlString = pullRequestViewUrlString
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
    // swiftlint:enabled line_length
    // sourcery:end
}
