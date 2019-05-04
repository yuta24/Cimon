//
//  Anchor.swift
//  Shared
//
//  Created by Yu Tawata on 2019/05/04.
//

import Foundation
import UIKit

public class Anchor {
    let base: UIView

    init(base: UIView) {
        base.translatesAutoresizingMaskIntoConstraints = false
        self.base = base
    }

    public func fixedToSuperView() {
        guard let superview = base.superview else {
            return
        }

        NSLayoutConstraint.activate([
            base.topAnchor.constraint(equalTo: superview.topAnchor),
            base.leadingAnchor.constraint(equalTo: superview.leadingAnchor),
            base.trailingAnchor.constraint(equalTo: superview.trailingAnchor),
            base.bottomAnchor.constraint(equalTo: superview.bottomAnchor)])
    }
}

extension UIView {
    public var anchor: Anchor {
        return Anchor(base: self)
    }
}
