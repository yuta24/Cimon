//
//  UIRefreshControl+Handler.swift
//  Shared
//
//  Created by Yu Tawata on 2019/05/05.
//

import Foundation
import UIKit

extension UIRefreshControl: HasAssociatedObjects {
    var holders: [HandlerHolder] {
        get {
            return (associatedObjects["closures"] as? [HandlerHolder]) ?? []
        }
        set {
            associatedObjects["closures"] = newValue
        }
    }
}

public extension UIRefreshControl {
    func addEventHandler(for event: UIControl.Event, handler: @escaping () -> Void) {
        let holder = HandlerHolder(closure: handler)
        addTarget(holder, action: #selector(HandlerHolder.handler), for: event)
        holders.append(holder)
    }

    func removeEventHandler(for event: UIControl.Event) {
        holders.forEach({ (holder) in
            removeTarget(holder, action: #selector(HandlerHolder.handler), for: event)
        })
    }
}
