//
//  MainViewController.swift
//  App
//
//  Created by Yu Tawata on 2019/05/04.
//

import Foundation
import UIKit
import Pipeline
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
        let storage: StorageProtocol
        let presenter: MainViewPresenterProtocol
    }

    @IBOutlet weak var contentView: UIView!

    private let page: UIPageViewController = UIPageViewController(
        transitionStyle: .scroll,
        navigationOrientation: .horizontal,
        options: nil)

    private lazy var pages: [CI: UIViewController] = {
        let travisCIController = Scenes.travisCI
            .execute(.init(
                network: travisCIService,
                storage: self.dependency.storage,
                presenter: TravisCIViewPresenter()))
        travisCIController.delegate = self

        let circleCIController = Scenes.circleCI
            .execute(.init(presenter: CircleCIViewPresenter()))

        let bitriseController = Scenes.bitrise
            .execute(.init(
                network: bitriseService,
                storage: self.dependency.storage,
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
            image: Asset.outlineSettingsBlack36pt.image,
            style: .plain,
            target: self,
            action: #selector(onLeftTapped(_:)))

        add(child: page)
        page.view.anchor.fixedToSuperView()
        page.dataSource = self
        page.delegate = self
        let initial = [pages[dependency.presenter.state.selected]!]
        page.setViewControllers(initial, direction: .forward, animated: true, completion: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.navigationBar.setBackgroundColor(.white)

        dependency.presenter.subscribe(configure(_:))
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        navigationController?.navigationBar.clearBackgroundColor()

        dependency.presenter.unsubscribe()
    }

    func inject(dependency: MainViewController.Dependency) {
        self.dependency = dependency
    }

    private func configure(_ state: Main.State) {
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
