//
//  Extend.swift
//  Shared
//
//  Created by Yu Tawata on 2019/07/07.
//

import Foundation

public struct Extend<Base> where Base: ExtendProvider {
    public var base: Base
}

public protocol ExtendProvider {
}

extension ExtendProvider {
    public var ext: Extend<Self> {
        return Extend(base: self)
    }
}
