//
//  App.swift
//  App
//
//  Created by Yu Tawata on 2019/05/04.
//

import Foundation
import UIKit
import Pipeline
import Shared
import Domain
import Core

public class App {
    public let window: UIWindow
    public let environment: Environment

    public init(window: UIWindow, store: StoreProtocol, reporter: ReporterProtocol, sceneFactory: SceneFactoryProtocol, networks: [CI: NetworkServiceProtocol]) {
        self.window = apply(window, {
            $0.rootViewController = MainViewController.Dependency(
                store: store,
                networks: networks,
                presenter: MainViewPresenter(ci: .travisci, dependency: .init(store: store, networks: networks)))
                |> Scenes.main.execute
                |> UINavigationController.init
            $0.makeKeyAndVisible()
        })
        self.environment = Environment(store: store, networks: networks, sceneFactory: sceneFactory, reporter: reporter)
    }

    public func didFinishLaunching(withOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        return true
    }

    public func willResignActive() {
    }

    public func didEnterBackground() {
    }

    public func willEnterForeground() {
    }

    public func didBecomeActive() {
    }

    public func willTerminate() {
    }
}
