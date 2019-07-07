//
//  MainViewController.swift
//  App
//
//  Created by Yu Tawata on 2019/05/04.
//

import Foundation
import UIKit
import Shared
import Domain

protocol MainPageDelegate: class {
    func onScrollChanged(_ contentOffset: CGPoint)
}

class MainViewController: UIViewController, Instantiatable {
    enum Translator {
        static func convert(viewController: UIViewController) -> CI? {
            switch viewController {
            case is TravisCIViewController:
                return .travisci
            case is CircleCIViewController:
                return .circleci
            case is BitriseViewController:
                return .bitrise
            default:
                return nil
            }
        }

        static func convert(ci: CI) -> Reader<MainViewController, UIViewController?> {
            return .init({ (controller) -> UIViewController? in
                return controller.pages[ci]
            })
        }
    }

    struct Dependency {
        let store: StoreProtocol
        let presenter: MainViewPresenterProtocol
        let services: [CI: NetworkServiceProtocol]
    }

    @IBOutlet weak var contentView: UIView!

    private let page: UIPageViewController = UIPageViewController(
        transitionStyle: .scroll,
        navigationOrientation: .horizontal,
        options: .none)

    private lazy var pages: [CI: UIViewController] = {
        let travisCIController = Scenes.travisCI
            .execute(.init(
                network: self.dependency.services[.travisci]!,
                store: self.dependency.store,
                presenter: TravisCIViewPresenter()))
        travisCIController.delegate = self

        let circleCIController = Scenes.circleCI
            .execute(.init(
                network: self.dependency.services[.circleci]!,
                store: self.dependency.store,
                presenter: CircleCIViewPresenter()))
        circleCIController.delegate = self

        let bitriseController = Scenes.bitrise
            .execute(.init(
                network: self.dependency.services[.bitrise]!,
                store: self.dependency.store,
                presenter: BitriseViewPresenter()))
        bitriseController.delegate = self

        return [
            .travisci: travisCIController,
            .circleci: circleCIController,
            .bitrise: bitriseController]
    }()

    private var dependency: Dependency!

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: Asset.settings.image,
            style: .plain,
            target: self,
            action: #selector(onLeftTapped(_:)))

        add(child: page)
        page.view.anchor.fixedToSuperView()
        page.dataSource = self
        page.delegate = self
        let initial = [pages[dependency.presenter.state.selected]!]
        page.setViewControllers(initial, direction: .forward, animated: true, completion: .none)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        dependency.presenter.subscribe(configure(_:))
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        dependency.presenter.unsubscribe()
    }

    func inject(dependency: MainViewController.Dependency) {
        self.dependency = dependency
    }

    private func configure(_ state: MainScene.State) {
        navigationItem.title = state.selected.description
    }

    @objc private func onLeftTapped(_ sender: UIBarButtonItem) {
        dependency.presenter.route(event: .settings).execute(self)
    }
}

extension MainViewController: MainPageDelegate {
    func onScrollChanged(_ contentOffset: CGPoint) {
    }
}

extension MainViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        return dependency.presenter.state.before
            .flatMap(Translator.convert)?
            .execute(self)
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        return dependency.presenter.state.after
            .flatMap(Translator.convert)?
            .execute(self)
    }
}

extension MainViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        // no operation.
    }

    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard completed else {
            return
        }
        pageViewController.viewControllers?.first
            .flatMap { Translator.convert(viewController: $0) }
            .flatMap { dependency.presenter.dispatch(.update($0)) }
    }
}
