//
//  UIViewController+Extension.swift
//  Shared
//
//  Created by Yu Tawata on 2019/05/04.
//

import Foundation
import UIKit

extension UIViewController {
    public static var bundle: Bundle {
        return Bundle(for: self)
    }

    public var bundle: Bundle {
        return Bundle(for: type(of: self))
    }

    public func add(child: UIViewController, to view: UIView? = nil) {
        addChild(child)
        (view ?? self.view).addSubview(child.view)
        child.didMove(toParent: self)
    }

    public func remove(child: UIViewController) {
        child.willMove(toParent: .none)
        child.view.removeFromSuperview()
        child.removeFromParent()
    }
}
