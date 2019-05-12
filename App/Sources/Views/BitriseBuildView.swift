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
class BitriseBuildView: UIView {
    @IBOutlet weak var statusLabel: UILabel!
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
    struct Context {
        var status: String
        var owner: String
        var repositoryName: String
        var branchName: String
        var targetBranchName: String?
        var commitMessage: String
        var triggeredWorkflow: String
        var triggeredAt: String
    }

    func configure(_ context: BitriseBuildView.Context) {
        statusLabel.text = context.status
        ownerLabel.text = context.owner
        repositoryNameLabel.text = context.repositoryName
        branchNameLabel.text = context.branchName
        targetBranchNameLabel.text = context.targetBranchName
        commitMessageLabel.text = context.commitMessage
        triggeredWorkflowLabel.text = context.triggeredWorkflow
        triggeredAtLabel.text = context.triggeredAt
    }
}
