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
import Core

// sourcery: scene
public class BitriseDetailViewController: UIViewController, Instantiatable {
    public struct Dependency {
        public let network: NetworkServiceProtocol
        public let store: StoreProtocol
        public let presenter: BitriseDetailViewPresenterProtocol

        public init(
            network: NetworkServiceProtocol,
            store: StoreProtocol,
            presenter: BitriseDetailViewPresenterProtocol) {
            self.network = network
            self.store = store
            self.presenter = presenter
        }
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

    public func inject(dependency: BitriseDetailViewController.Dependency) {
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
