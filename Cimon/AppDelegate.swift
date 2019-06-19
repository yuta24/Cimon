//
//  AppDelegate.swift
//  Cimon
//
//  Created by Yu Tawata on 2019/05/04.
//  Copyright © 2019 Yu Tawata. All rights reserved.
//

import UIKit
import Shared
import App
import FirebaseCore

let logger = LightLogger.self
let store = LocalStore(userDefaults: .standard)
let reporter = CrashlyticsReporter()

let app = App(
    window: UIWindow(frame: UIScreen.main.bounds),
    store: store,
    reporter: reporter,
    services: [
        .travisci: travisCIService,
        .circleci: circleCIService,
        .bitrise: bitriseService])

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        window = app.window
        FirebaseApp.configure()
        return app.didFinishLaunching(withOptions: launchOptions)
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        app.willResignActive()
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        app.didEnterBackground()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        app.willEnterForeground()
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        app.didBecomeActive()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        app.willTerminate()
    }

}
