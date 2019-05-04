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
        let presenter: TravisCIViewPresenterProtocol
    }

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var tableView: UITableView!

    @IBOutlet weak var unregisteredView: UIView!

    private var presenter: TravisCIViewPresenterProtocol!

    func inject(dependency: TravisCIViewController.Dependency) {
        self.presenter = dependency.presenter
    }
}
