//
//  Value.swift
//  Litey
//
//  Created by Yu Tawata on 2020/08/11.
//

import Foundation

public enum ValueType {
    case integer
    case real
    case text

    var typeName: String {
        switch self {
        case .integer:
            return "INTEGER"
        case .real:
            return "REAL"
        case .text:
            return "TEXT"
        }
    }
}

public protocol Value {
    static var valueType: ValueType { get }
}

extension Int64: Value {
    public static  var valueType: ValueType {
        .integer
    }
}

extension Double: Value {
    public static  var valueType: ValueType {
        .real
    }
}

extension String: Value {
    public static  var valueType: ValueType {
        .text
    }
}
