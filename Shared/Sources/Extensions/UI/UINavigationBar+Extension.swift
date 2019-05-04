//
//  UINavigationBar+Extension.swift
//  Shared
//
//  Created by Yu Tawata on 2019/05/04.
//

import Foundation
import UIKit

extension UINavigationBar {
    public func setTransparent() {
        setBackgroundImage(UIImage(), for: .default)
        shadowImage = UIImage()
    }

    public func clearTransparent() {
        setBackgroundImage(nil, for: .default)
        shadowImage = nil
    }
}
