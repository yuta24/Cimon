//
//  CircleCIViewController.swift
//  App
//
//  Created by Yu Tawata on 2019/05/04.
//

import Foundation
import UIKit
import Shared
import Domain

class CircleCIViewController: UIViewController, Instantiatable {
    struct Dependency {
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .red
    }

    func inject(dependency: CircleCIViewController.Dependency) {
    }
}
