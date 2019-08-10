//
//  TabItemCell.swift
//  App
//
//  Created by Yu Tawata on 2019/08/08.
//

import Foundation
import UIKit
import Shared

class TabItemCell: UICollectionViewCell, CellRegisterable {
    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            titleLabel.textAlignment = .center
        }
    }
}

extension TabItemCell: Configurable {
    struct Context {
        var title: String
    }

    func configure(_ context: TabItemCell.Context) {
        titleLabel.text = context.title
    }
}
