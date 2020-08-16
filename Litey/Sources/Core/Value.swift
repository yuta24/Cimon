//
//  Value.swift
//  Litey
//
//  Created by Yu Tawata on 2020/08/11.
//

import Foundation

public protocol StorageType {
    static var typeName: String { get }
}

public enum Integer: StorageType {
    public static var typeName: String {
        return "INTEGER"
    }
}

public enum Real: StorageType {
    public static var typeName: String {
        return "REAL"
    }
}

public enum Text: StorageType {
    public static var typeName: String {
        return "TEXT"
    }
}

public enum Blob: StorageType {
    public static var typeName: String {
        return "BLOB"
    }
}

public protocol Value {
}

public protocol Binding {
    associatedtype Storage: StorageType
}

extension Int64: Value, Binding {
    public typealias Storage = Integer
}

extension Double: Value, Binding {
    public typealias Storage = Real
}

extension String: Value, Binding {
    public typealias Storage = Text
}

extension Data: Value, Binding {
    public typealias Storage = Blob
}

//extension Optional: Value where Wrapped: Value {
//}
