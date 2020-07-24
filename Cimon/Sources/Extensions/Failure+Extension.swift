//
//  Failure+Extension.swift
//  Cimon
//
//  Created by Yu Tawata on 2020/07/11.
//

import Foundation
import Mocha

extension Client.Failure: Equatable {
    public static func == (lhs: Client.Failure, rhs: Client.Failure) -> Bool {
        switch (lhs, rhs) {
        case (.network, .network):
            return true
        case (.decode(let l), .decode(let r)):
            return l.localizedDescription == r.localizedDescription
        default:
            return false
        }
    }
}
