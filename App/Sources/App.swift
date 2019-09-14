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
        let mainViewController = MainViewPresenter(ci: .travisci, dependency: .init(store: store, networks: networks))
            |> { MainViewController.Dependency(store: store, networks: networks, presenter: $0) }
            |> { Scenes.main.execute($0) }

        let pages: [(CI, UIViewController)] = {
            let travisCIController = Scenes.travisCI.execute(
                .init(presenter:
                    TravisCIViewPresenter(
                        dependency: .init(
                            fetchUseCase: FetchBuildsFromTravisCI(
                                network: networks[.travisci]!),
                            store: store,
                            network: networks[.travisci]!))))

            let circleCIController = Scenes.circleCI.execute(
                .init(presenter:
                    CircleCIViewPresenter(
                        dependency: .init(
                            fetchUseCase: FetchBuildsFromCircleCI(
                                network: networks[.circleci]!),
                            store: store))))

            let bitriseController = sceneFactory.bitrise(context: .none, with: .init(fetchUseCase: FetchBuildsFromBitrise(
                network: networks[.bitrise]!), store: store, network: networks[.bitrise]!, sceneFactory: sceneFactory))

            return [
                (.travisci, travisCIController),
                (.circleci, circleCIController),
                (.bitrise, bitriseController)]
        }()

        mainViewController.pages = pages

        self.window = apply(window, {
            $0.rootViewController = UINavigationController(rootViewController: mainViewController)
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
