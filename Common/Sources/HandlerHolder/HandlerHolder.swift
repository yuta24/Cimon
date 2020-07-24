//
//  HandlerHolder.swift
//  Shared
//
//  Created by Yu Tawata on 2019/05/05.
//

import Foundation

public class HandlerHolder {
    let closure: () -> Void

    public init(closure: @escaping () -> Void) {
        self.closure = {
            closure()
        }
    }

    @objc
    public func handler() {
        closure()
    }
}
