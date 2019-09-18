//
//  SceneDelegate.swift
//  Cimon
//
//  Created by Yu Tawata on 2019/09/19.
//

import UIKit
import Shared
import App
import FirebaseCore

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        return process(
            app.willConnect(to: session, options: connectionOptions),
            pre: {
                if let windowScene = scene as? UIWindowScene {
                    app.configure(window: UIWindow(windowScene: windowScene))
                }
                window = app.window
            },
            post: {
                FirebaseApp.configure()
            })
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        app.didDisconnect()
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        app.didBecomeActive()
    }

    func sceneWillResignActive(_ scene: UIScene) {
        app.willResignActive()
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        app.willEnterForeground()
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        app.didEnterBackground()
    }
}
