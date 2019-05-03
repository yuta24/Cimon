//
//  MainViewController.swift
//  App
//
//  Created by Yu Tawata on 2019/05/04.
//

import Foundation
import UIKit
import Shared

class MainViewController: UIViewController, Instantiatable {
    struct Dependency {
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func inject(dependency: MainViewController.Dependency) {
    }
}
