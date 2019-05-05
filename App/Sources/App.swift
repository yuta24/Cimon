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

public class App {
    public let window: UIWindow
    public let environment: Environment

    public init (window: UIWindow, storage: Storage) {
        self.window = apply(window, {
            $0.rootViewController = (storage, MainViewPresenter(ci: .travisci))
                |> MainViewController.Dependency.init
                |> Scenes.main.execute
                |> UINavigationController.init
            $0.makeKeyAndVisible()
        })
        self.environment = Environment(storage: storage)
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
