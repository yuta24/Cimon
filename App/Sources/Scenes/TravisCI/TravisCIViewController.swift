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
        let storage: Storage
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
    @IBOutlet weak var unregisteredButton: UIButton! {
        didSet {
            unregisteredButton.setTitleColor(.black, for: .normal)
            unregisteredButton.setTitle("Set", for: .normal)
            unregisteredButton.addEventHandler(for: .touchUpInside) { [weak self] in
                self?.onUnregistered()
            }
        }
    }

    private var dependency: Dependency!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        dependency.presenter.load().execute(dependency.storage)
        dependency.presenter.subscribe(configure(_:))
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        dependency.presenter.unsubscribe()
    }

    func inject(dependency: TravisCIViewController.Dependency) {
        self.dependency = dependency
    }

    private func configure(_ state: TravisCI.State) {
        logger.debug(#function)

        contentView.isHidden = state.isUnregistered
        unregisteredView.isHidden = !state.isUnregistered
    }

    @objc private func onUnregistered() {
        let alert = UIAlertController(title: "", message: "Set access token", preferredStyle: .alert)
        alert.addTextField()
        alert.addAction(UIAlertAction(title: "OK", style: .default) { [weak self, weak alert] _ in
            guard let `self` = self else {
                return
            }
            self.dependency.presenter
                .dispatch(.token(alert?.textFields?.first?.text))
                .execute(self.dependency.storage)
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true)
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
