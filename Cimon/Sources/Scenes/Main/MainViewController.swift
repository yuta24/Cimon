//
//  MainViewController.swift
//  App
//
//  Created by Yu Tawata on 2019/05/04.
//

import UIKit
import Overture
import Common
import Domain
import TravisCI
import CircleCI
import Bitrise
import Core

class MainViewController: UIViewController, Instantiatable {
    enum Transformer {
        static func transform(viewController: UIViewController) -> CI? {
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

        static func transform(ci: CI) -> ReaderM<MainViewController, UIViewController?> {
            return .init({ (controller) -> UIViewController? in
                return controller.pages.first(where: { (_ci, _) in _ci == ci })?.1
            })
        }
    }

    struct Dependency {
        let presenter: MainViewPresenterProtocol
        let route: (UIViewController, Main.Transition.Event) -> Void
    }

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var tabBar: TabBar! {
        didSet {
            tabBar.itemSelected = { [weak self] (index) in
                DispatchQueue.main.async {
                    self?.update(index)
                }
            }
        }
    }
    @IBOutlet weak var pageView: UIView!

    private let page: UIPageViewController = UIPageViewController(
        transitionStyle: .scroll,
        navigationOrientation: .horizontal,
        options: .none)

    var pages = [(CI, UIViewController)]()

    private var dependency: Dependency!

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Cimon"
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: Asset.settings.image,
            style: .plain,
            target: self,
            action: #selector(onLeftTapped(_:)))

        add(child: page, to: pageView)
        page.view.anchor.fixedToSuperView()
        page.dataSource = self
        page.delegate = self
        let initial = [pages.first(where: { (_ci, _) in _ci == dependency.presenter.state.selected })!.1]
        page.setViewControllers(initial, direction: .forward, animated: true, completion: .none)

        tabBar.configure(.init(titles: pages.map({ (ci, _) in ci.description })))
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
        if let index = pages.firstIndex(where: { (ci, _) in ci == state.selected }) {
            tabBar.move(to: index)
        }
    }

    private func update(_ index: Int) {
        let item = pages[index]
        let direction: UIPageViewController.NavigationDirection? = {
            switch (dependency.presenter.state.selected, item.0) {
            case (.travisci, .circleci):
                return .forward
            case (.travisci, .bitrise):
                return .forward
            case (.circleci, .bitrise):
                return .forward
            case (.bitrise, .circleci):
                return .reverse
            case (.bitrise, .travisci):
                return .reverse
            case (.circleci, .travisci):
                return .reverse
            default:
                return nil
            }
        }()

        if let _direction = direction {
            page.setViewControllers([item.1], direction: _direction, animated: true) { [weak self] (finished) in
                guard finished else {
                    return
                }
                self?.dependency.presenter.dispatch(.update(item.0))
            }
        }
    }

    @objc private func onLeftTapped(_ sender: UIBarButtonItem) {
        dependency.route(self, .settings)
    }
}

extension MainViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        return dependency.presenter.state.before
            .flatMap(Transformer.transform)?
            .run(self)
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        return dependency.presenter.state.after
            .flatMap(Transformer.transform)?
            .run(self)
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
            .flatMap(Transformer.transform(viewController:))
            .flatMap(MainScene.Message.update)
            .flatMap(dependency.presenter.dispatch)
    }
}
