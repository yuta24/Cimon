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
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.tableFooterView = UIView()
            tableView.dataSource = self
            tableView.delegate = self
        }
    }

    @IBOutlet weak var unregisteredView: UIView!
    @IBOutlet weak var unregisteredLabel: UILabel! {
        didSet {
            unregisteredLabel.numberOfLines = 0
            unregisteredLabel.textAlignment = .center
            unregisteredLabel.text = "Set Travis CI's API access token."
        }
    }
    @IBOutlet weak var unregisterdButton: RoundedButton! {
        didSet {
            unregisterdButton.setTitle("Set", for: .normal)
        }
    }

    private var presenter: TravisCIViewPresenterProtocol!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        presenter.subscribe(configure(_:))
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        presenter.unsubscribe()
    }

    func inject(dependency: TravisCIViewController.Dependency) {
        self.presenter = dependency.presenter
    }

    private func configure(_ state: TravisCI.State) {
        logger.debug(#function)

        contentView.isHidden = state.isUnregistered
        unregisteredView.isHidden = !state.isUnregistered
    }
}

extension TravisCIViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}

extension TravisCIViewController: UITableViewDelegate {
}
