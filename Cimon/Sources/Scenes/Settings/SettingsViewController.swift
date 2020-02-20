//
//  SettingsViewController.swift
//  App
//
//  Created by Yu Tawata on 2019/07/13.
//

import UIKit
import Common
import BitriseAPI
import Domain
import Core

class SettingsViewController: UIViewController, Instantiatable {
    struct Dependency {
        let presenter: SettingsViewPresenterProtocol
        let route: (UIViewController, Settings.Transition.Event) -> Void
    }

    enum SectionKind: Int {
        case tokens
        case app
    }

    enum ItemKind: Hashable {
        case token(CI, String?)
        case version(String)

        var title: String? {
            switch self {
            case .token(let ci, _):
                return ci.description
            case .version:
                return "Version"
            }
        }

        var value: String? {
            switch self {
            case .token(_, let rawValue):
                return rawValue
            case .version(let rawValue):
                return rawValue
            }
        }
    }

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            apply(tableView, mainSceneStyle)
            tableView.delegate = self
        }
    }

    private lazy var dataSource = UITableViewDiffableDataSource<SectionKind, ItemKind>(tableView: tableView) { (_, indexPath, itemKind) -> UITableViewCell? in
        switch SectionKind(rawValue: indexPath.section)! {
        case .tokens:
            let cell = UITableViewCell.init(style: .value1, reuseIdentifier: nil)
            cell.textLabel?.text = itemKind.title
            cell.detailTextLabel?.text = itemKind.value.isNil ? "Unauthorized" : "Authorized"
            cell.accessoryType = .disclosureIndicator
            return cell
        case .app:
            let cell = UITableViewCell.init(style: .value1, reuseIdentifier: nil)
            cell.textLabel?.text = itemKind.title
            cell.detailTextLabel?.text = itemKind.value
            cell.selectionStyle = .none
            return cell
        }
    }
    private var dependency: Dependency!

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Settings"
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        dependency.presenter.dispatch(.load)

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
        var snapshot = NSDiffableDataSourceSnapshot<SectionKind, ItemKind>()
        snapshot.appendSections([.tokens, .app])
        snapshot.appendItems([
            .token(.travisci, state.travisCIToken?.value),
            .token(.circleci, state.circleCIToken?.value),
            .token(.bitrise, state.bitriseToken?.value)
        ], toSection: .tokens)
        snapshot.appendItems([.version(state.version)], toSection: .app)

        dataSource.apply(snapshot)
    }
}

extension SettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        defer {
            tableView.deselectRow(at: indexPath, animated: true)
        }

        switch SectionKind(rawValue: indexPath.section)! {
        case .tokens:
            let ci: CI = {
                switch indexPath.item {
                case 0:
                    return .travisci
                case 1:
                    return .circleci
                case 2:
                    return .bitrise
                default:
                    fatalError()
                }
            }()
            dependency.route(self, .detail(ci))
        case .app:
            break
        }
    }
}
