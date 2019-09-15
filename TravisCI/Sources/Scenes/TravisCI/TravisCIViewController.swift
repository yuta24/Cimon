//
//  TravisCIViewController.swift
//  App
//
//  Created by Yu Tawata on 2019/05/04.
//

import Foundation
import UIKit
import Pipeline
import TravisCIAPI
import Shared
import Domain
import Core

public class TravisCIViewController: UIViewController, Instantiatable {
    public struct Dependency {
        public let presenter: TravisCIViewPresenterProtocol

        public init(presenter: TravisCIViewPresenterProtocol) {
            self.presenter = presenter
        }
    }

    enum SectionKind: Int {
        case builds
    }

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            apply(collectionView, mainSceneStyle)
            collectionView.refreshControl = refreshControl
            collectionView.delegate = self
            collectionView.collectionViewLayout = { () -> UICollectionViewLayout in
                return UICollectionViewCompositionalLayout(sectionProvider: { (_, _) -> NSCollectionLayoutSection? in
                    return NSCollectionLayoutSection(
                        group: NSCollectionLayoutGroup.horizontal(
                            layoutSize: NSCollectionLayoutSize(
                                widthDimension: .fractionalWidth(1.0),
                                heightDimension: .estimated(44)),
                            subitems: [
                                NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(44)))
                        ]))
                })
            }()
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

    private lazy var dataSource = UICollectionViewDiffableDataSource<SectionKind, Standard.Build>(collectionView: collectionView) { (collectionView, indexPath, build) -> UICollectionViewCell? in
        let cell = TravisCIBuildStatusCell.dequeue(for: indexPath, from: collectionView)
        cell.configure(.init(child: build))
        return cell
    }
    private let refreshControl = UIRefreshControl()
    private var dependency: Dependency!
    private var observations = [NSKeyValueObservation]()

    public override func viewDidLoad() {
        super.viewDidLoad()

        apply(refreshControl) { (control) in
            control.addEventHandler(for: .valueChanged) { [weak self] in
                guard let `self` = self else {
                    return
                }
                self.dependency.presenter.dispatch(.fetch)
            }
        }

        observations.append(collectionView.observe(\.contentOffset, options: [.old, .new]) { [weak self] (tableView, _) in
            guard let `self` = self else {
                return
            }
            logger.debug(tableView.nearBottom)

            if tableView.nearBottom {
                self.dependency.presenter.dispatch(.fetchNext)
            }
        })
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        dependency.presenter.dispatch(.load)
        dependency.presenter.dispatch(.fetch)

        dependency.presenter.subscribe(configure(_:))
    }

    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        dependency.presenter.unsubscribe()
    }

    public func inject(dependency: TravisCIViewController.Dependency) {
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

        var snapshot = NSDiffableDataSourceSnapshot<SectionKind, Standard.Build>()
        snapshot.appendSections([.builds])
        snapshot.appendItems(state.builds)

        dataSource.apply(snapshot)
    }

    @objc private func onUnregistered() {
        let alert = UIAlertController(title: "", message: "Set access token", preferredStyle: .alert)
        alert.addTextField()
        alert.addAction(UIAlertAction(title: "OK", style: .default) { [weak self, weak alert] _ in
            guard let `self` = self else {
                return
            }
            self.dependency.presenter.dispatch(.token(alert?.textFields?.first?.text))
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: .none))
        present(alert, animated: true)
    }
}

extension TravisCIViewController: UICollectionViewDelegate {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
    }

    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        defer {
            collectionView.deselectItem(at: indexPath, animated: true)
        }

        if let item = dataSource.itemIdentifier(for: indexPath) {
            dependency.presenter.route(from: self, event: .detail(buildId: item.id))
        }
    }
}
