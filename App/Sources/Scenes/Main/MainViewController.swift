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
        let presenter: MainViewPresenterProtocol
    }

    @IBOutlet weak var contentView: UIView!

    private let page: UIPageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)

    private let pages: [CI: UIViewController] = [
        .travisci: Scenes.travisCI.execute(.init()),
        .circleci: Scenes.circleCI.execute(.init()),
        .bitrise: Scenes.bitrise.execute(.init())]

    private var presenter: MainViewPresenterProtocol!

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
        page.setViewControllers([pages[presenter.state.selected]!], direction: .forward, animated: true, completion: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.navigationBar.setTransparent()

        presenter.subscribe { [weak self] (state) in
            self?.navigationItem.title = state.selected.description
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        navigationController?.navigationBar.clearTransparent()

        presenter.unsubscribe()
    }

    func inject(dependency: MainViewController.Dependency) {
        self.presenter = dependency.presenter
    }

    @objc private func onLeftTapped(_ sender: UIBarButtonItem) {
        logger.debug(#function)
    }
}

extension MainViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        return presenter.state.before
            .flatMap(Translator.convert)?
            .execute(self)
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        return presenter.state.after
            .flatMap(Translator.convert)?
            .execute(self)
    }
}

extension MainViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        // nop
    }

    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard completed else {
            return
        }
        pageViewController.viewControllers?.first
            .flatMap { Translator.convert(viewController: $0) }
            .flatMap { presenter.dispatch(.update($0)) }
    }
}
