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
        alert.addAction(.init(title: "OK", style: .default, handler: .none))
        controller.present(alert, animated: true, completion: .none)
    default:
        fatalError()
    }
}
