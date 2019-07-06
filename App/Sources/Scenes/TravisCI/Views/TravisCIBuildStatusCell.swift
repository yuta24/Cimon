//
//  TravisCIBuildStatusCell.swift
//  App
//
//  Created by Yu Tawata on 2019/07/06.
//

import Foundation
import UIKit
import Shared

class TravisCIBuildStatusCell: UICollectionViewCell, CellRegisterable {
    @IBOutlet weak var buildView: TravisCIBuildView!
}

extension TravisCIBuildStatusCell: Configurable {
    struct Context {
        var child: TravisCIBuildView.Context
    }

    func configure(_ context: TravisCIBuildStatusCell.Context) {
        buildView.configure(context.child)
    }
}
