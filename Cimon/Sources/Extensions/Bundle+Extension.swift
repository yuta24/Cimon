//
//  Bundle+Extension.swift
//  App
//
//  Created by Yu Tawata on 2019/05/04.
//

import Foundation

extension Bundle {
    class Inner {
    }

    static var current: Bundle {
        return Bundle(for: Inner.self)
    }
}
