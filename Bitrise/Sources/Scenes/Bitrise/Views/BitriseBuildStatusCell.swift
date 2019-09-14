//
//  BitriseBuildStatusCell.swift
//  App
//
//  Created by Yu Tawata on 2019/05/11.
//

import Foundation
import UIKit
import Shared

class BitriseBuildStatusCell: UICollectionViewCell, CellRegisterable {
    @IBOutlet weak var buildView: BitriseBuildView!

    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        guard let superview = superview else {
            return layoutAttributes
        }

        var targetSize = UIView.layoutFittingCompressedSize
        targetSize.width = superview.frame.width

        layoutAttributes.size = contentView.systemLayoutSizeFitting(
            targetSize,
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel)

        return layoutAttributes
    }
}

extension BitriseBuildStatusCell: Configurable {
    struct Context {
        var child: BitriseBuildView.Context
    }

    func configure(_ context: BitriseBuildStatusCell.Context) {
        buildView.configure(context.child)
    }
}
