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

class MainViewController: UIViewController, Instantiatable {
    struct Dependency {
        let presenter: MainViewPresenterProtocol
    }

    @IBOutlet weak var contentView: UIView!

    private let page: UIPageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)

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
    }

    func inject(dependency: MainViewController.Dependency) {
        self.presenter = dependency.presenter
    }

    @objc private func onLeftTapped(_ sender: UIBarButtonItem) {
        logger.debug(#function)
    }
}
