//
//  Utility.swift
//  Shared
//
//  Created by Yu Tawata on 2019/06/26.
//

import Foundation

@discardableResult
public func process<T>(_ original: @autoclosure () -> T, pre: () -> Void = {}, post: () -> Void = {}) -> T {
    pre()
    let result = original()
    post()
    return result
}

@discardableResult
public func completion<T>(_ original: @autoclosure () -> T, completion: () -> Void) -> T {
    let result = original()
    completion()
    return result
}
