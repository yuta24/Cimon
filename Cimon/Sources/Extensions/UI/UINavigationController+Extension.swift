//
//  UINavigationController+Extension.swift
//  App
//
//  Created by Yu Tawata on 2019/05/05.
//

import Foundation
import UIKit
import Core

extension UINavigationController {
    convenience init(rootViewController: UIViewController, hasClose: Bool) {
        self.init(rootViewController: rootViewController)
        rootViewController.navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: Asset.deleteFilled.image,
            style: .plain,
            target: self,
            action: #selector(onClose))
    }

    @objc private func onClose() {
        dismiss(animated: true, completion: .none)
    }
}
