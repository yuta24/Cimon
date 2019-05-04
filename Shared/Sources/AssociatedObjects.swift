//
//  AssociatedObjects.swift
//  Shared
//
//  Created by Yu Tawata on 2019/05/04.
//

import Foundation

public class AssociatedObjects: NSObject {
    var dictionary: [String: Any] = [:]

    public subscript(key: String) -> Any? {
        get {
            return self.dictionary[key]
        }
        set {
            self.dictionary[key] = newValue
        }
    }
}

public protocol HasAssociatedObjects: AnyObject {
    var associatedObjects: AssociatedObjects { get }
}

private var AssociatedObjectsKey: UInt8 = 0

public extension HasAssociatedObjects {
    var associatedObjects: AssociatedObjects {
        guard let associatedObjects = objc_getAssociatedObject(self, &AssociatedObjectsKey) as? AssociatedObjects else {
            let associatedObjects = AssociatedObjects()
            objc_setAssociatedObject(self, &AssociatedObjectsKey, associatedObjects, .OBJC_ASSOCIATION_RETAIN)
            return associatedObjects
        }
        return associatedObjects
    }
}
