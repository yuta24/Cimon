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

public class App {
    public let window: UIWindow

    public init (window: UIWindow) {
        self.window = apply(window, {
            $0.rootViewController = Scenes.main.execute(.init(presenter: MainViewPresenter(ci: .travisci)))
                |> UINavigationController.init
            $0.makeKeyAndVisible()
        })
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
