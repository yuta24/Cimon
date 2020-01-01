//
//  UIScrollView+Extension.swift
//  Shared
//
//  Created by Yu Tawata on 2019/05/06.
//

import Foundation
import UIKit

public extension UIScrollView {
    var nearBottom: Bool {
        let visibleHeight = frame.height - contentInset.top - contentInset.bottom
        let y = contentOffset.y + contentInset.top
        let threshold = max(0.0, contentSize.height - visibleHeight)

        return y > threshold ? true : false
    }
}
