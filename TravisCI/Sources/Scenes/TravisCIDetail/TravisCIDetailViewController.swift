//
//  TravisCIDetailViewController.swift
//  App
//
//  Created by Yu Tawata on 2019/08/11.
//

import UIKit
import Common
import TravisCIAPI
import Domain
import Core

public class TravisCIDetailViewController: UIViewController, Instantiatable {
    public struct Dependency {
        public let presenter: TravisCIDetailViewPresenterProtocol

        public init(presenter: TravisCIDetailViewPresenterProtocol) {
            self.presenter = presenter
        }
    }

    enum SectionKind: Int {
        case build
        case jobs
    }

    enum ItemKind: Hashable {
        case build(Standard.Build)
        case job(Standard.Job)
    }

    @IBOutlet weak var contentView: UIScrollView!
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            apply(tableView, mainSceneStyle)
            tableView.delegate = self
            tableView.separatorStyle = .none
            tableView.tableFooterView = UIView()
        }
    }

    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView! {
        didSet {
            activityIndicatorView.hidesWhenStopped = true
        }
    }

    private lazy var dataSource = UITableViewDiffableDataSource<SectionKind, ItemKind>(tableView: tableView) { (_, indexPath, itemKind) -> UITableViewCell? in
        switch (SectionKind(rawValue: indexPath.section), itemKind) {
        case (.some(.build), .build(let build)):
            let cell = UITableViewCell.init(style: .value1, reuseIdentifier: nil)
            cell.selectionStyle = .none
            cell.textLabel?.text = build.commit?.message
            return cell
        case (.some(.jobs), .job(let job)):
            let cell = UITableViewCell.init(style: .value1, reuseIdentifier: nil)
            cell.textLabel?.text = job.number
            return cell
        case (.some(.build), .job):
            return nil
        case (.some(.jobs), .build):
            return nil
        case (.none, _):
            return nil
        }
    }

    private var dependency: Dependency!
    private var observations = [NSKeyValueObservation]()

    public override func viewDidLoad() {
        super.viewDidLoad()
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        dependency.presenter.dispatch(.fetch)

        dependency.presenter.subscribe(configure(_:))
    }

    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        dependency.presenter.unsubscribe()
    }

    public func inject(dependency: TravisCIDetailViewController.Dependency) {
        self.dependency = dependency
    }

    private func configure(_ state: TravisCIDetailScene.State) {
        if state.isLoading {
            activityIndicatorView.startAnimating()
        } else {
            activityIndicatorView.stopAnimating()
        }

        contentView.isHidden = !state.isUnregistered

        var snapshot = NSDiffableDataSourceSnapshot<SectionKind, ItemKind>()
        if let detail = state.detail {
            snapshot.appendSections([.build, .jobs])
            snapshot.appendItems([.build(detail.0)], toSection: .build)
            snapshot.appendItems(detail.1.map(ItemKind.job), toSection: .jobs)
        }

        dataSource.apply(snapshot)
    }
}

extension TravisCIDetailViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
