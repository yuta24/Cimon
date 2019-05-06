//
//  Optional+Extension.swift
//  Shared
//
//  Created by Yu Tawata on 2019/05/06.
//

import Foundation

public extension Optional {
    var isNil: Bool {
        if case .some = self {
            return false
        } else {
            return true
        }
    }

    func condition(where closure: (Wrapped) -> Bool) -> Bool {
        switch self {
        case .some(let wrapped):
            return closure(wrapped)
        case .none:
            return false
        }
    }
}
