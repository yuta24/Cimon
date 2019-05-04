//
//  TravisCIViewController.swift
//  App
//
//  Created by Yu Tawata on 2019/05/04.
//

import Foundation
import UIKit
import Shared
import Domain

class TravisCIViewController: UIViewController, Instantiatable {
    struct Dependency {
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .green
    }

    func inject(dependency: TravisCIViewController.Dependency) {
    }
}
