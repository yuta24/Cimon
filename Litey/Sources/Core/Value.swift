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
    associatedtype Storage: StorageType
}

extension Int64: Value {
    public typealias Storage = Integer
}

extension Double: Value {
    public typealias Storage = Real
}

extension String: Value {
    public typealias Storage = Text
}

extension Data: Value {
    public typealias Storage = Blob
}
