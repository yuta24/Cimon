//
//  HandlerHolder.swift
//  Shared
//
//  Created by Yu Tawata on 2019/05/05.
//

import Foundation

class HandlerHolder {
    let closure: () -> Void

    init(closure: @escaping () -> Void) {
        self.closure = {
            closure()
        }
    }

    @objc
    func handler() {
        closure()
    }
}
