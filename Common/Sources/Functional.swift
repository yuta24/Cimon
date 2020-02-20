//
//  Functional.swift
//  Shared
//
//  Created by Yu Tawata on 2019/05/04.
//

import Foundation

@discardableResult
public func apply<T>(_ target: T, _ closure: (T) -> Void) -> T where T: AnyObject {
    closure(target)
    return target
}
