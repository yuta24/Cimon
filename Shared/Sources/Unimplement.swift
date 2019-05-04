//
//  Unimplement.swift
//  Shared
//
//  Created by Yu Tawata on 2019/05/04.
//

import Foundation
import UIKit

public func unimplement<T>(_ target: T) {
    switch target {
    case let controller as UIViewController:
        let alert = UIAlertController(title: "ERROR", message: "unimplemented", preferredStyle: .alert)
        alert.addAction(.init(title: "OK", style: .default, handler: nil))
        controller.present(alert, animated: true, completion: nil)
    default:
        fatalError()
    }
}
