//
//  UICollectionView+CellRegisterable.swift
//  Shared
//
//  Created by Yu Tawata on 2019/05/05.
//

import Foundation
import UIKit

extension UICollectionView: HasAssociatedObjects {
    var registered: [String] {
        get {
            return (associatedObjects["registerd"] as? [String]) ?? []
        }
        set {
            associatedObjects["registerd"] = newValue
        }
    }
}

public extension UICollectionView {
    func register<C>(_ cellClass: C.Type) where C: UICollectionViewCell & CellRegisterable {
        let register = C.register()

        switch register.method {
        case .class:
            self.register(cellClass, forCellWithReuseIdentifier: register.identifier)
        case .nib(let nib):
            self.register(nib, forCellWithReuseIdentifier: register.identifier)
        }
    }

    func dequeue<C>(for indexPath: IndexPath) -> C where C: UICollectionViewCell & CellRegisterable {
        let register = C.register()

        if !registered.contains(register.identifier) {
            self.register(C.self)
            registered.append(register.identifier)
        }

        return dequeueReusableCell(withReuseIdentifier: register.identifier, for: indexPath) as! C // swiftlint:disable:this force_cast
    }
}

public extension CellRegisterable where Self: UICollectionViewCell {
    static func dequeue(for indexPath: IndexPath, from collectionView: UICollectionView) -> Self {
        return collectionView.dequeue(for: indexPath) as Self
    }
}
