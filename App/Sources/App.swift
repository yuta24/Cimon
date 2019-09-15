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
    public let sceneFactory: SceneFactoryProtocol

    public init(window: UIWindow, environment: Environment) {
        let sceneFactory = SceneFactory(environment: { () -> Environment in
            return environment
        })

        self.window = window
        self.sceneFactory = sceneFactory

        let mainViewController = sceneFactory.main(
            context: .init(
                selected: .travisci,
                pages: { () -> [(CI, UIViewController)] in
                    let travisCIController = sceneFactory.travisCI(context: .none)
                    let circleCIController = sceneFactory.circleCI(context: .none)
                    let bitriseController = sceneFactory.bitrise(context: .none)

                    return [
                        (.travisci, travisCIController),
                        (.circleci, circleCIController),
                        (.bitrise, bitriseController)]
                }()))

        apply(window, {
            $0.rootViewController = UINavigationController(rootViewController: mainViewController)
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
