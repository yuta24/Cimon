//
//  RoundedImageView.swift
//  App
//
//  Created by Yu Tawata on 2019/07/25.
//

import Foundation
import UIKit

@IBDesignable
class RoundedImageView: UIImageView {
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = true
        }
    }

    @IBInspectable
    var borderColor: UIColor? {
        get {
            return layer.borderColor.flatMap(UIColor.init)
        }
        set {
            layer.borderColor = newValue?.cgColor
            layer.masksToBounds = true
        }
    }

    @IBInspectable
    var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
            layer.masksToBounds = true
        }
    }
}
