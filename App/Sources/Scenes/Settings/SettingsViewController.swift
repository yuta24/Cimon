//
//  SettingsViewController.swift
//  App
//
//  Created by Yu Tawata on 2019/07/13.
//

import Foundation
import UIKit
import Pipeline
import BitriseAPI
import Shared
import Domain

class SettingsViewController: UIViewController, Instantiatable {
    struct Dependency {
        let store: StoreProtocol
        let presenter: SettingsViewPresenterProtocol
    }

    enum SectionKind: Int {
        case tokens
        case app
    }

    enum ItemKind: Hashable {
        case token(String)
        case version(String)
    }

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            apply(tableView, mainSceneStyle)
            tableView.delegate = self
        }
    }

    private lazy var dataSource = UITableViewDiffableDataSource<SectionKind, ItemKind>(tableView: tableView) { (tableView, indexPath, itemKind) -> UITableViewCell? in
        switch SectionKind(rawValue: indexPath.section)! {
        case .tokens:
            let cell = UITableViewCell()
            cell.textLabel
            return cell
        case .app:
            let cell = UITableViewCell()
            cell.textLabel
            return cell
        }
    }
//    (tableView: tableView) { (tableView, indexPath, item) -> UICollectionViewCell? in
//        switch SectionKind(rawValue: indexPath.section)! {
//        }
//        let cell = BitriseBuildStatusCell.dequeue(for: indexPath, from: collectionView)
//        cell.configure(.init(child: build))
//        return UITableViewCell()
//    }
    private var dependency: Dependency!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        dependency.presenter.dispatch(.load).execute(.init(store: dependency.store))

        dependency.presenter.subscribe(configure(_:))
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        dependency.presenter.unsubscribe()
    }

    func inject(dependency: SettingsViewController.Dependency) {
        self.dependency = dependency
    }

    private func configure(_ state: SettingsScene.State) {
        let snapshot = apply(NSDiffableDataSourceSnapshot<SectionKind, ItemKind>(), { (snapshot) in
//            snapshot.appendSections([])
//            snapshot.appendItems(state.builds)
        })
//        dataSource.apply(snapshot)
    }
}

extension SettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
