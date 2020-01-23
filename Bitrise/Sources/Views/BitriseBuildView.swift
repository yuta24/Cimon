//
//  BitriseBuildView.swift
//  App
//
//  Created by Yu Tawata on 2019/05/08.
//

import UIKit
import Common
import BitriseAPI
import Core

@IBDesignable
class BitriseBuildView: RoundedView {
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
        Xib<BitriseBuildView>().load(to: self)
    }
}

extension BitriseBuildView: Configurable {
    typealias Context = BuildListAllResponseItemModel

    func configure(_ context: BitriseBuildView.Context) {
        statusColorView.backgroundColor = context.ext.status?.color
        statusLabel.text = context.statusText
        buildNumberLabel.text = context.buildNumber
            .flatMap(String.init)
            .flatMap({ "# \($0)" })
        zip(context.repository?.repoOwner, context.repository?.repoSlug, {
            slugLabel.text = "\($0)/\($1)"
        })
        branchLabel.text = context.branch
        descriptionLabel.text = context.commitMessage
        timestampLabel.text = context.triggeredAt

        durationLabel.isHidden = false
    }
}
