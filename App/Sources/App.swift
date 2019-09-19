//
//  App.swift
//  App
//
//  Created by Yu Tawata on 2019/05/04.
//

import Foundation
import UIKit
import SwiftUI
import Pipeline
import Shared
import Domain
import Core

public class App {
    @ObservedObject public var store: Store<AppState, AppAction>
    public private(set) var window: UIWindow!

    let sceneFactory: SceneFactoryProtocol

    public init(store: Store<AppState, AppAction>, environment: Environment) {
        let sceneFactory = SceneFactory(environment: { () -> Environment in
            return environment
        })

        self.store = store
        self.sceneFactory = sceneFactory
    }

    public func configure(window: UIWindow) {
        self.window = window

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

    public func willConnect(to session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    }

    public func didDisconnect() {
    }

    public func didBecomeActive() {
    }

    public func willResignActive() {
    }

    public func willEnterForeground() {
    }

    public func didEnterBackground() {
    }
}
