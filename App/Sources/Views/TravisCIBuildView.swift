//
//  TravisCIBuildView.swift
//  App
//
//  Created by Yu Tawata on 2019/07/06.
//

import Foundation
import UIKit
import TravisCIAPI
import Shared
import Core

@IBDesignable
class TravisCIBuildView: RoundedView {
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
        Xib<TravisCIBuildView>().load(to: self)
    }
}

extension TravisCIBuildView: Configurable {
    typealias Context = TravisCIAPI.Standard.Build

    func configure(_ context: TravisCIBuildView.Context) {
        statusColorView.backgroundColor = context.ext.status?.color
        statusLabel.text = context.state
        buildNumberLabel.text = "# \(context.number)"
        slugLabel.text = context.repository?.slug
        branchLabel.text = context.branch?.name
        descriptionLabel.text = context.commit?.message
        timestampLabel.text = context.startedAt
        durationLabel.text = "\(context.duration)"
    }
}
