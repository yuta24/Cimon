//
//  UIColor+Extension.swift
//  App
//
//  Created by Yu Tawata on 2019/07/12.
//

import UIKit
import Common
import SwiftUI

extension UIColor: ExtendProvider {
}

extension Extend where Base == UIColor {
    var color: Color {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        base.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        return Color(red: Double(red), green: Double(green), blue: Double(blue))
    }
}
