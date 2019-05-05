//
//  UITableView+CellRegistable.swift
//  Shared
//
//  Created by Yu Tawata on 2019/05/05.
//

import Foundation
import UIKit

extension UITableView: HasAssociatedObjects {
    var registered: [String] {
        get {
            return (associatedObjects["registerd"] as? [String]) ?? []
        }
        set {
            associatedObjects["registerd"] = newValue
        }
    }
}

public extension UITableView {
    func register<C>(_ cellClass: C.Type) where C: UITableViewCell & CellRegisterable {
        let register = C.register()

        switch register.method {
        case .class:
            self.register(cellClass, forCellReuseIdentifier: register.identifier)
        case .nib(let nib):
            self.register(nib, forCellReuseIdentifier: register.identifier)
        }
    }

    func dequeue<C>(for indexPath: IndexPath) -> C where C: UITableViewCell & CellRegisterable {
        let register = C.register()

        if !registered.contains(register.identifier) {
            self.register(C.self)
            registered.append(register.identifier)
        }

        return dequeueReusableCell(withIdentifier: register.identifier, for: indexPath) as! C // swiftlint:disable:this force_cast
    }
}

public extension CellRegisterable where Self: UITableViewCell {
    static func dequeue(for indexPath: IndexPath, from tableView: UITableView) -> Self {
        return tableView.dequeue(for: indexPath) as Self
    }
}
