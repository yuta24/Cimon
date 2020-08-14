//
//  Data+Extension.swift
//  Litey
//
//  Created by Yu Tawata on 2020/08/14.
//

import Foundation

extension Data {
    public func toHex() -> String {
        return map { data in String(format: "%02.2hhx", data) }.joined()
    }
}
