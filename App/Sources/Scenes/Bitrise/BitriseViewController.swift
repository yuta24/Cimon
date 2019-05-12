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
        let network: NetworkServiceProtocol
        let storage: StorageProtocol
        let presenter: BitriseViewPresenterProtocol
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
            unregisteredLabel.text = "Set Bitrise's API access token."
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
                    .execute(.init(network: self.dependency.network, storage: self.dependency.storage))
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
                    .execute(.init(network: self.dependency.network, storage: self.dependency.storage))
            }
        })
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        dependency.presenter.load()
            .execute(.init(network: dependency.network, storage: dependency.storage))
        dependency.presenter.dispatch(.fetch)
            .execute(.init(network: dependency.network, storage: dependency.storage))
        dependency.presenter.subscribe(configure(_:))
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        dependency.presenter.unsubscribe()
    }

    func inject(dependency: BitriseViewController.Dependency) {
        self.dependency = dependency
    }

    private func configure(_ state: Bitrise.State) {
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
                .execute(.init(network: self.dependency.network, storage: self.dependency.storage))
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
}

extension BitriseViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dependency.presenter.state.builds.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let build = dependency.presenter.state.builds[indexPath.row]
        let cell = BitriseBuildStatusCell.dequeue(for: indexPath, from: tableView)
        zip(build.statusText, build.repository?.owner?.name, build.repository?.title, build.branch, build.commitMessage, build.triggeredWorkflow, build.triggeredAt) {
            (statusText: String, ownerName: String, repositoryTitle: String, branch: String, commitMessage: String, triggeredWorkflow: String, triggeredAt: String) in // swiftlint:disable:this closure_parameter_position
            cell.configure(.init(context: .init(status: statusText, owner: ownerName, repositoryName: repositoryTitle, branchName: branch, targetBranchName: build.pullRequestTargetBranch, commitMessage: commitMessage, triggeredWorkflow: triggeredWorkflow, triggeredAt: triggeredAt)))
        }
        return cell
    }
}

extension BitriseViewController: UITableViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        delegate?.onScrollChanged(scrollView.contentOffset)
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
