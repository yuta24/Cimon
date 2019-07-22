//
//  CISettingViewController.swift
//  App
//
//  Created by Yu Tawata on 2019/07/20.
//

import Foundation
import UIKit
import Pipeline
import BitriseAPI
import Shared
import Domain

// sourcery: scene
class CISettingViewController: UIViewController, Instantiatable {
    struct Dependency {
        let store: StoreProtocol
        let presenter: CISettingViewPresenterProtocol
    }

    @IBOutlet weak var contentView: UIView!

    private var dependency: Dependency!

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Settings"
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

    func inject(dependency: CISettingViewController.Dependency) {
        self.dependency = dependency
    }

    private func configure(_ state: CISettingScene.State) {
    }
}
