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

class BitriseBuildView: UIView {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    private func commonInit() {
        Xib(bundle: .current).load(to: self)
    }
}
