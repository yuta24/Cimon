//
//  CellRegisterable.swift
//  Shared
//
//  Created by Yu Tawata on 2019/05/05.
//

import Foundation
import UIKit

public struct CellRegister {
    public enum MethodKind {
        case `class`
        case nib(UINib)
    }

    public let identifier: String
    public let method: MethodKind

    public init(
        identifier: String,
        method: MethodKind
        ) {
        self.identifier = identifier
        self.method = method
    }
}

public protocol CellRegisterable {
    static func register() -> CellRegister
}

public extension CellRegisterable {
    static func register() -> CellRegister {
        let identifier = String(describing: self)
        return CellRegister(identifier: identifier, method: .nib(UINib(nibName: identifier, bundle: nil)))
    }
}
