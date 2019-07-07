//
//  CircleCIBuildView.swift
//  App
//
//  Created by Yu Tawata on 2019/07/07.
//

import Foundation
import UIKit
import CircleCIAPI
import Shared

@IBDesignable
class CircleCIBuildView: RoundedView {
    @IBOutlet weak var statusColorView: UIView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var buildNumberLabel: UILabel!
    @IBOutlet weak var slugLabel: UILabel!
    @IBOutlet weak var branchLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    private func commonInit() {
        Xib<CircleCIBuildView>().load(to: self)
    }
}

extension CircleCIBuildView: Configurable {
    typealias Context = CircleCIAPI.Build

    func configure(_ context: CircleCIBuildView.Context) {
        statusColorView.backgroundColor = context.ext.status?.color
        statusLabel.text = context.status
        buildNumberLabel.text = "# \(context.buildNum)"
        slugLabel.text = "\(context.username)/\(context.reponame)"
        branchLabel.text = context.branch
        descriptionLabel.text = context.subject
        timestampLabel.text = context.queuedAt
        durationLabel.text = "\(context.buildTimeMillis)"
    }
}
