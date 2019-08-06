//
//  BitriseViewController.swift
//  App
//
//  Created by Yu Tawata on 2019/05/04.
//

import Foundation
import UIKit
import Pipeline
import BitriseAPI
import Shared
import Domain

// sourcery: scene
class BitriseViewController: UIViewController, Instantiatable {
    struct Dependency {
        var presenter: BitriseViewPresenterProtocol
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
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView! {
        didSet {
            activityIndicatorView.hidesWhenStopped = true
        }
    }

    weak var delegate: MainPageDelegate?

    private lazy var dataSource = UICollectionViewDiffableDataSource<SectionKind, BuildListAllResponseItemModel>(collectionView: collectionView) { (collectionView, indexPath, build) -> UICollectionViewCell? in
        let cell = BitriseBuildStatusCell.dequeue(for: indexPath, from: collectionView)
        cell.configure(.init(child: build))
        return cell
    }
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
            }
        }

        observations.append(collectionView.observe(\.contentOffset, options: [.old, .new]) { [weak self] (collectionView, _) in
            guard let `self` = self else {
                return
            }

            if collectionView.nearBottom {
                self.dependency.presenter.dispatch(.fetchNext)
            }
        })
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        dependency.presenter.dispatch(.load)
        dependency.presenter.dispatch(.fetch)

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
        if state.isLoading {
            activityIndicatorView.startAnimating()
        } else {
            activityIndicatorView.stopAnimating()
        }

        refreshControl.endRefreshing()
        contentView.isHidden = state.isUnregistered
        unregisteredView.isHidden = !state.isUnregistered

        let snapshot = apply(NSDiffableDataSourceSnapshot<SectionKind, BuildListAllResponseItemModel>(), { (snapshot) in
            snapshot.appendSections([.builds])
            snapshot.appendItems(state.builds)
        })
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

extension BitriseViewController: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        delegate?.onScrollChanged(scrollView.contentOffset)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}
