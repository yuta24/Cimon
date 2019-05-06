//
//  SettingsViewController.swift
//  App
//
//  Created by Yu Tawata on 2019/05/05.
//

import Foundation
import UIKit
import Shared

class SettingsViewController: UIViewController, Instantiatable {
    struct Dependency {
    }

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.tableFooterView = UIView()
            tableView.dataSource = self
            tableView.delegate = self
        }
    }

    func inject(dependency: SettingsViewController.Dependency) {
    }
}

extension SettingsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}

extension SettingsViewController: UITableViewDelegate {
}
