//
//  BitriseDetailViewController.swift
//  App
//
//  Created by Yu Tawata on 2019/07/01.
//

import Foundation
import UIKit
import Pipeline
import Shared
import Domain

// sourcery: scene
class BitriseDetailViewController: UIViewController, Instantiatable {
    struct Dependency {
        let network: NetworkServiceProtocol
        let store: StoreProtocol
        let presenter: BitriseDetailViewPresenterProtocol
    }

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var textView: UITextView! {
        didSet {
            apply(textView, terminalStyle)
        }
    }

    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView! {
        didSet {
            activityIndicatorView.hidesWhenStopped = true
        }
    }

    private var dependency: Dependency!
    private var observations = [NSKeyValueObservation]()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        dependency.presenter.dispatch(.fetch)

        dependency.presenter.subscribe(configure(_:))
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        dependency.presenter.unsubscribe()
    }

    func inject(dependency: BitriseDetailViewController.Dependency) {
        self.dependency = dependency
    }

    private func configure(_ state: BitriseDetailScene.State) {
        if state.isLoading {
            activityIndicatorView.startAnimating()
        } else {
            activityIndicatorView.stopAnimating()
        }

        contentView.isHidden = !state.isUnregistered

        textView.text = state.log?.logChunks?.map({ $0.chunk }).joined(separator: "\n")
    }
}
