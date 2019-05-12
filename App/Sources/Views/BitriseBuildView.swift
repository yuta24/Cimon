//
//  BitriseBuildView.swift
//  App
//
//  Created by Yu Tawata on 2019/05/08.
//

import Foundation
import UIKit
import BitriseAPI
import Shared

@IBDesignable
class BitriseBuildView: RoundedView {
    @IBOutlet weak var statusWrapperView: UIView!
    @IBOutlet weak var statusLabel: UILabel! {
        didSet {
            statusLabel.textColor = Asset.base02.color
        }
    }
    @IBOutlet weak var ownerLabel: UILabel!
    @IBOutlet weak var repositoryNameLabel: UILabel!
    @IBOutlet weak var branchNameLabel: UILabel!
    @IBOutlet weak var targetBranchNameLabel: UILabel!
    @IBOutlet weak var commitMessageLabel: UILabel!
    @IBOutlet weak var triggeredWorkflowLabel: UILabel!
    @IBOutlet weak var triggeredAtLabel: UILabel!

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    private func commonInit() {
        Xib<BitriseBuildView>(bundle: .current).load(to: self)
    }
}

extension BitriseBuildView: Configurable {
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
                return Asset.buildStatusSuccess.color
            case .aborted:
                return Asset.buildStatusAborted.color
            case .error:
                return Asset.buildStatusFailed.color
            }
        }
    }

    struct Context {
        var status: String
        var owner: String
        var repositoryName: String
        var branchName: String
        var targetBranchName: String?
        var commitMessage: String?
        var triggeredWorkflow: String
        var triggeredAt: String
    }

    func configure(_ context: BitriseBuildView.Context) {
        let status = Status(rawValue: context.status)
        statusWrapperView.backgroundColor = status?.color
        statusLabel.text = status?.rawValue.uppercased()
        ownerLabel.text = context.owner
        repositoryNameLabel.text = context.repositoryName
        branchNameLabel.text = context.branchName
        targetBranchNameLabel.text = context.targetBranchName
        commitMessageLabel.text = context.commitMessage
        triggeredWorkflowLabel.text = context.triggeredWorkflow
        triggeredAtLabel.text = context.triggeredAt
    }
}
