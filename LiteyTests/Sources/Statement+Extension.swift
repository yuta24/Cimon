//
//  Statement+Extension.swift
//  LiteyTests
//
//  Created by Yu Tawata on 2020/08/12.
//

import Foundation
import SQLite3
@testable import Litey

extension Statement: CustomDebugStringConvertible {
    public var debugDescription: String {
        var names = [String]()
        for i in 0 ..< sqlite3_column_count(statement) {
            let name = String(cString: UnsafePointer(sqlite3_column_name(statement, i)))
            names.append("\(i):\(name)")
        }

        return names.joined(separator: "|")
    }
}
