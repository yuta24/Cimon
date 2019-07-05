//
//  TravisCIViewController.swift
//  App
//
//  Created by Yu Tawata on 2019/05/04.
//

import Foundation
import UIKit
import Pipeline
import Shared
import Domain

class TravisCIViewController: UIViewController, Instantiatable {
    struct Dependency {
        let network: NetworkServiceProtocol
        let store: StoreProtocol
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
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView! {
        didSet {
            activityIndicatorView.hidesWhenStopped = true
        }
    }

    weak var delegate: MainPageDelegate?

    private let refreshControl = UIRefreshControl()
    private var dependency: Dependency!
    private var observations = [NSKeyValueObservation]()

    override func viewDidLoad() {
        super.viewDidLoad()

        apply(refreshControl) { (control) in
            control.addEventHandler(for: .valueChanged) { [weak self] in
                guard let `self` = self else {
                    return
                }
                self.dependency.presenter.dispatch(.fetch)
                    .execute(.init(network: self.dependency.network, store: self.dependency.store))
            }
        }
        tableView.refreshControl = refreshControl

        observations.append(tableView.observe(\.contentOffset, options: [.old, .new]) { [weak self] (tableView, _) in
            guard let `self` = self else {
                return
            }
            logger.debug(tableView.nearBottom)

            if tableView.nearBottom {
                self.dependency.presenter.dispatch(.fetchNext)
                    .execute(.init(network: self.dependency.network, store: self.dependency.store))
            }
        })
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        TravisCIScene.Dependency(network: dependency.network, store: dependency.store) |> {
            self.dependency.presenter.dispatch(.load).execute($0)
            self.dependency.presenter.dispatch(.fetch).execute($0)
        }

        dependency.presenter.subscribe(configure(_:))
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        dependency.presenter.unsubscribe()
    }

    func inject(dependency: TravisCIViewController.Dependency) {
        self.dependency = dependency
    }

    private func configure(_ state: TravisCIScene.State) {
        if state.isLoading {
            activityIndicatorView.startAnimating()
        } else {
            activityIndicatorView.stopAnimating()
        }

        refreshControl.endRefreshing()
        contentView.isHidden = state.isUnregistered
        unregisteredView.isHidden = !state.isUnregistered

        tableView.reloadData()
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
                .execute(.init(network: self.dependency.network, store: self.dependency.store))
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: .none))
        present(alert, animated: true)
    }
}

extension TravisCIViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dependency.presenter.state.builds.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = dependency.presenter.state.builds[indexPath.row].repository?.slug
        return cell
    }
}

extension TravisCIViewController: UITableViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        delegate?.onScrollChanged(scrollView.contentOffset)
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
