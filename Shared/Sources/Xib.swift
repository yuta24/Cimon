//
//  Xib.swift
//  Shared
//
//  Created by Yu Tawata on 2019/05/08.
//

import Foundation
import UIKit

public struct Xib<V> where V: UIView {
    let bundle: Bundle
    let name: String?
    let owner: Any?

    public init(bundle: Bundle, name: String? = nil, owner: Any? = nil) {
        self.bundle = bundle
        self.name = name
        self.owner = owner
    }

    public func load(to view: UIView) {
        let contentView = bundle.loadNibNamed(name ?? String(describing: V.self), owner: owner ?? view, options: nil)?.first as! UIView // swiftlint:disable:this force_cast

        view.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: view.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor)])
    }
}
