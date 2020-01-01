//
//  SceneFactory.swift
//  Cimon
//
//  Created by tawata-yu on 2019/09/13.
//

import Foundation
import UIKit
import Shared
import Domain
import TravisCI
import CircleCI
import Bitrise
import Core

final class SceneFactory: SceneFactoryProtocol {
    let environment: () -> Environment

    init(environment: @escaping () -> Environment) {
        self.environment = environment
    }

    func main(context: Main.Context) -> UIViewController {
        let presenter = MainViewPresenter(
            .init(selected: context.selected),
            dependency: .init())

        let controller = Storyboard<MainViewController>(name: "Main")
            .instantiate(
                dependency: .init(
                    presenter: presenter,
                    route: { [unowned self] from, event in
                        switch event {
                        case .settings:
                            let controller = self.settings(context: .none)
                            let navigation = UINavigationController(rootViewController: controller, hasClose: true)
                            from.present(navigation, animated: true, completion: .none)
                    }
                }))
        controller.pages = context.pages

        return controller
    }

    func travisCI(context: TravisCI.Context) -> UIViewController {
        let presenter = TravisCIViewPresenter(
            dependency: .init(
                fetchUseCase: FetchBuildsFromTravisCI(client: environment().clients[.travisci]!),
                store: environment().store))

        let controller = Storyboard<TravisCIViewController>(name: "TravisCI")
            .instantiate(
                dependency: .init(
                    presenter: presenter,
                    route: { [unowned self] from, event in
                    switch event {
                    case .detail(let buildId):
                        let controller = self.travisCIDetail(context: .init(buildId: buildId))
                        from.navigationController?.pushViewController(controller, animated: true)
                    }
                }))

        return controller
    }

    func travisCIDetail(context: TravisCIDetail.Context) -> UIViewController {
        let presenter = TravisCIDetailViewPresenter(
            .init(buildId: context.buildId),
            dependency: .init(
                interactor: TravisCIDetailInteractor(
                    fetchBuildTravisCI: FetchBuildFromTravisCI(client: environment().clients[.travisci]!),
                    fetchJobsTravisCI: FetchJobsFromTravisCI(client: environment().clients[.travisci]!))))

        let controller = Storyboard<TravisCIDetailViewController>(name: "TravisCIDetail").instantiate(dependency: .init(presenter: presenter))

        return controller
    }

    func circleCI(context: CircleCI.Context) -> UIViewController {
        let presenter = CircleCIViewPresenter(
            dependency: .init(
                fetchUseCase: FetchBuildsFromCircleCI(client: environment().clients[.circleci]!),
                store: environment().store))

        let controller = Storyboard<CircleCIViewController>(name: "CircleCI")
            .instantiate(
                dependency: .init(
                    presenter: presenter,
                    route: { _, _ in }))

        return controller
    }

    func bitrise(context: Bitrise.Context) -> UIViewController {
        let presenter = BitriseViewPresenter(
            dependency: .init(
                fetchUseCase: FetchBuildsFromBitrise(client: environment().clients[.bitrise]!),
                store: environment().store))

        let controller = Storyboard<BitriseViewController>(name: "Bitrise")
            .instantiate(
                dependency: .init(
                    presenter: presenter,
                    route: { [unowned self] from, event in
                        switch event {
                        case .detail(let repository, let build):
                            let controller = self.bitriseDetail(context: .init(appSlug: repository, buildSlug: build))
                            from.navigationController?.pushViewController(controller, animated: true)
                        }
                }))

        return controller
    }

    func bitriseDetail(context: BitriseDetail.Context) -> UIViewController {
        let presenter = BitriseDetailViewPresenter(
            .init(appSlug: context.appSlug, buildSlug: context.buildSlug),
            dependency: .init(
                store: environment().store,
                client: environment().clients[.bitrise]!))

        let controller = Storyboard<BitriseDetailViewController>(name: "BitriseDetail").instantiate(dependency: .init(presenter: presenter))

        return controller
    }

    func settings(context: Settings.Context) -> UIViewController {
        let presenter = SettingsViewPresenter(
            dependency: .init(store: environment().store, clients: environment().clients))

        let controller = Storyboard<SettingsViewController>(name: "Settings")
            .instantiate(
                dependency: .init(
                    presenter: presenter,
                    route: { [unowned self] from, event in
                        switch event {
                        case .detail(let ci):
                            let controller = self.ciSetting(context: .init(ci: ci))
                            from.navigationController?.pushViewController(controller, animated: true)
                        }
                }))

        return controller
    }

    func ciSetting(context: CISetting.Context) -> UIViewController {
        let presenter = CISettingViewPresenter(
            .init(ci: context.ci),
            dependency: .init(
                interactor: CISettingInteractor(
                    store: environment().store,
                    fetchMeTravisCI: FetchMeFromTravisCI(client: environment().clients[.travisci]!),
                    fetchMeCircleCI: FetchMeFromCircleCI(client: environment().clients[.circleci]!),
                    fetchMeBitrise: FetchMeFromBitrise(client: environment().clients[.bitrise]!))))

        let controller = Storyboard<CISettingViewController>(name: "CISetting").instantiate(dependency: .init(presenter: presenter))

        return controller
    }
}
