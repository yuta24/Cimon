//
//  Lens.swift
//  Shared
//
//  Created by Yu Tawata on 2019/06/30.
//

import Foundation

public struct Lens<Whole, Part> {
    public let getter: (Whole) -> Part
    public let setter: (Whole, Part) -> Whole
}

public struct Prism<Whole, Part> {
    public let tryGet: (Whole) -> Part?
    public let inject: (Part) -> Whole
}
