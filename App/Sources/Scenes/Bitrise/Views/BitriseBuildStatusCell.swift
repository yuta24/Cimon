//
//  BitriseBuildStatusCell.swift
//  App
//
//  Created by Yu Tawata on 2019/05/11.
//

import Foundation
import UIKit
import Shared

class BitriseBuildStatusCell: UITableViewCell, CellRegisterable {
    @IBOutlet weak var buildView: BitriseBuildView!
}

extension BitriseBuildStatusCell: Configurable {
    struct Context {
        var context: BitriseBuildView.Context
    }

    func configure(_ context: BitriseBuildStatusCell.Context) {
        buildView.configure(context.context)
    }
}
