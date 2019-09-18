//
//  CircleCIBuildStatusCell.swift
//  App
//
//  Created by Yu Tawata on 2019/07/07.
//

import Foundation
import UIKit
import Shared

class CircleCIBuildStatusCell: UICollectionViewCell, CellRegisterable {
    @IBOutlet weak var buildView: CircleCIBuildView!
}

extension CircleCIBuildStatusCell: Configurable {
    struct Context {
        var child: CircleCIBuildView.Context
    }

    func configure(_ context: CircleCIBuildStatusCell.Context) {
        buildView.configure(context.child)
    }
}
