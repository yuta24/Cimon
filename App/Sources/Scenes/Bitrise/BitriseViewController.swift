//
//  BitriseViewController.swift
//  App
//
//  Created by Yu Tawata on 2019/05/04.
//

import Foundation
import UIKit
import Shared
import Domain

class BitriseViewController: UIViewController, Instantiatable {
    struct Dependency {
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .blue
    }

    func inject(dependency: BitriseViewController.Dependency) {
    }
}
