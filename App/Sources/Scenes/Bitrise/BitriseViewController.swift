//
//  BitriseViewController.swift
//  App
//
//  Created by Yu Tawata on 2019/05/04.
//

import Foundation
import UIKit
import Pipeline
import Shared
import Domain

class BitriseViewController: UIViewController, Instantiatable {
    struct Dependency {
        let network: NetworkServiceProtocol
        let store: StoreProtocol
        let presenter: BitriseViewPresenterProtocol
    }

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
                layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
                layout.minimumInteritemSpacing = 0
                layout.minimumLineSpacing = 0
            }
            collectionView.backgroundColor = .clear
            collectionView.dataSource = self
            collectionView.delegate = self
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
                    .execute(.init(network: self.dependency.network, store: self.dependency.store))
            }
        }
        collectionView.refreshControl = refreshControl

        observations.append(collectionView.observe(\.contentOffset, options: [.old, .new]) { [weak self] (collectionView, _) in
            guard let `self` = self else {
                return
            }

            if collectionView.nearBottom {
                self.dependency.presenter.dispatch(.fetchNext)
                    .execute(.init(network: self.dependency.network, store: self.dependency.store))
            }
        })
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        BitriseScene.Dependency(network: dependency.network, store: dependency.store) |> {
            self.dependency.presenter.dispatch(.load).execute($0)
            self.dependency.presenter.dispatch(.fetch).execute($0)
        }

        dependency.presenter.subscribe(configure(_:))
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        dependency.presenter.unsubscribe()
    }

    func inject(dependency: BitriseViewController.Dependency) {
        self.dependency = dependency
    }

    private func configure(_ state: BitriseScene.State) {
        refreshControl.endRefreshing()
        contentView.isHidden = state.isUnregistered
        unregisteredView.isHidden = !state.isUnregistered

        collectionView.reloadData()
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
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
}

extension BitriseViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dependency.presenter.state.builds.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let build = dependency.presenter.state.builds[indexPath.row]
        let cell = BitriseBuildStatusCell.dequeue(for: indexPath, from: collectionView)
        zip(build.statusText, build.repository?.owner?.name, build.repository?.slug, build.branch, build.triggeredWorkflow, build.triggeredAt) {
            (statusText: String, ownerName: String, repositoryTitle: String, branch: String, triggeredWorkflow: String, triggeredAt: String) in // swiftlint:disable:this closure_parameter_position
            cell.configure(.init(context: .init(
                status: statusText,
                owner: ownerName,
                repositoryName: repositoryTitle,
                branchName: branch,
                targetBranchName: build.pullRequestTargetBranch,
                commitMessage: build.commitMessage,
                triggeredWorkflow: triggeredWorkflow,
                triggeredAt: triggeredAt)))
        }
        return cell
    }
}

extension BitriseViewController: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        delegate?.onScrollChanged(scrollView.contentOffset)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}
