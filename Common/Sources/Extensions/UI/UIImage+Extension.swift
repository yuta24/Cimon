//
//  UIImage+Extension.swift
//  Shared
//
//  Created by Yu Tawata on 2019/05/06.
//

import Foundation
import UIKit

public extension UIImage {
    static func make(color: UIColor, size: CGSize = .init(width: 1, height: 1)) -> UIImage {
        return UIGraphicsImageRenderer(size: size).image { context in
            context.cgContext.setFillColor(color.cgColor)
            context.fill(CGRect(origin: .zero, size: size))
        }
    }
}
