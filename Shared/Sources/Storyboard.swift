//
//  Storyboard.swift
//  Shared
//
//  Created by Yu Tawata on 2019/05/04.
//

import Foundation

public struct Storyboard<V> where V: UIViewController {

    let bundle: Bundle
    let name: String
    var identifier: String?

    public init(bundle: Bundle, name: String, identifier: String? = nil) {
        self.bundle = bundle
        self.name = name
        self.identifier = identifier
    }

    public func instantiate() -> V {
        let storyboard = UIStoryboard(name: name, bundle: bundle)
        let identifier = self.identifier ?? String(describing: V.self)
        let controller = storyboard.instantiateViewController(withIdentifier: identifier) as! V // swiftlint:disable:this force_cast
        return controller
    }

}

public protocol Instantiatable {
    associatedtype Dependency

    func inject(dependency: Dependency)
}

extension Storyboard where V: Instantiatable {

    public func instantiate(dependency: V.Dependency) -> V {
        let controller = instantiate()
        controller.inject(dependency: dependency)
        return controller
    }

}
