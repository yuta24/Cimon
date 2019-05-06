//
//  UINavigationBar+Extension.swift
//  App
//
//  Created by Yu Tawata on 2019/05/06.
//

import Foundation
import UIKit
import Shared

extension UINavigationBar {
    func setBackgroundColor(_ color: UIColor) {
        setBackgroundImage(UIImage.make(color: color), for: .default)
    }

    func clearBackgroundColor() {
        setBackgroundImage(nil, for: .default)
    }
}
