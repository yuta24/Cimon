//
//  BitriseBuildStatusCell.swift
//  App
//
//  Created by Yu Tawata on 2019/05/11.
//

import UIKit
import Common

class BitriseBuildStatusCell: UICollectionViewCell, CellRegisterable {
    @IBOutlet weak var buildView: BitriseBuildView!
}

extension BitriseBuildStatusCell: Configurable {
    struct Context {
        var child: BitriseBuildView.Context
    }

    func configure(_ context: BitriseBuildStatusCell.Context) {
        buildView.configure(context.child)
    }
}
