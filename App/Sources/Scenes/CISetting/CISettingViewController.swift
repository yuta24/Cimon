//
//  CISettingViewController.swift
//  App
//
//  Created by Yu Tawata on 2019/07/20.
//

import Foundation
import UIKit
import Nuke
import Pipeline
import BitriseAPI
import Shared
import Domain

// sourcery: scene
class CISettingViewController: UIViewController, Instantiatable {
    struct Dependency {
        var presenter: CISettingViewPresenterProtocol
    }

    @IBOutlet weak var contentView: UIView!

    @IBOutlet weak var avatarImageView: RoundedImageView! {
        didSet {
            avatarImageView.image = UIImage.make(color: .systemGray4)
            avatarImageView.borderWidth = 4
            avatarImageView.borderColor = Asset.primary.color
        }
    }
    @IBOutlet weak var nameLabel: UILabel! {
        didSet {
            nameLabel.text = .none
            nameLabel.textAlignment = .center
        }
    }
    @IBOutlet weak var actionButton: RoundedButton! {
        didSet {
            actionButton.setTitle(.none, for: .normal)
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

    func inject(dependency: CISettingViewController.Dependency) {
        self.dependency = dependency
    }

    private func configure(_ state: CISettingScene.State) {
        navigationItem.title = state.ci.description

        if let url = state.avatarUrl {
            loadImage(with: url, into: avatarImageView)
        }
        nameLabel.text = state.name

        let title = state.authorized ? "Deauthorize" : "Authorize"
        actionButton.setTitle(title, for: .normal)
    }
}
