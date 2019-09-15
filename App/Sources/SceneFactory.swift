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
            dependency: .init(
                store: environment().store,
                networks: environment().networks,
                route: { [unowned self] from, event in
                    switch event {
                    case .settings:
                        let controller = self.settings(context: .none)
                        let navigation = UINavigationController(rootViewController: controller, hasClose: true)
                        from.present(navigation, animated: true, completion: .none)
                    }
            }))

        let controller = Storyboard<MainViewController>(name: "Main").instantiate(dependency: .init(presenter: presenter))
        controller.pages = context.pages

        return controller
    }

    func travisCI(context: TravisCI.Context) -> UIViewController {
        let presenter = TravisCIViewPresenter(
            dependency: .init(
                fetchUseCase: FetchBuildsFromTravisCI(network: environment().networks[.travisci]!),
                store: environment().store,
                network: environment().networks[.travisci]!,
                route: { [unowned self] from, event in
                    switch event {
                    case .detail(let buildId):
                        let controller = self.travisCIDetail(context: .init(buildId: buildId))
                        from.navigationController?.pushViewController(controller, animated: true)
                    }
                }))

        let controller = Storyboard<TravisCIViewController>(name: "TravisCI").instantiate(dependency: .init(presenter: presenter))

        return controller
    }

    func travisCIDetail(context: TravisCIDetail.Context) -> UIViewController {
        let presenter = TravisCIDetailViewPresenter(
            .init(buildId: context.buildId),
            dependency: .init(
                interactor: TravisCIDetailInteractor(
                    fetchBuildTravisCI: FetchBuildFromTravisCI(network: environment().networks[.travisci]!),
                    fetchJobsTravisCI: FetchJobsFromTravisCI(network: environment().networks[.travisci]!)),
                store: environment().store,
                network: environment().networks[.travisci]!))

        let controller = Storyboard<TravisCIDetailViewController>(name: "TravisCIDetail").instantiate(dependency: .init(presenter: presenter))

        return controller
    }

    func circleCI(context: CircleCI.Context) -> UIViewController {
        let presenter = CircleCIViewPresenter(
            dependency: .init(
                fetchUseCase: FetchBuildsFromCircleCI(network: environment().networks[.circleci]!),
                store: environment().store,
                route: { _, _ in }))

        let controller = Storyboard<CircleCIViewController>(name: "CircleCI").instantiate(dependency: .init(presenter: presenter))

        return controller
    }

    func bitrise(context: Bitrise.Context) -> UIViewController {
        let presenter = BitriseViewPresenter(
            dependency: .init(
                fetchUseCase: FetchBuildsFromBitrise(network: environment().networks[.bitrise]!),
                store: environment().store,
                network: environment().networks[.bitrise]!,
                route: { [unowned self] from, event in
                    switch event {
                    case .detail(let repository, let build):
                        let controller = self.bitriseDetail(context: .init(appSlug: repository, buildSlug: build))
                        from.navigationController?.pushViewController(controller, animated: true)
                    }
                }))

        let controller = Storyboard<BitriseViewController>(name: "Bitrise").instantiate(dependency: .init(presenter: presenter))

        return controller
    }

    func bitriseDetail(context: BitriseDetail.Context) -> UIViewController {
        let presenter = BitriseDetailViewPresenter(
            .init(appSlug: context.appSlug, buildSlug: context.buildSlug),
            dependency: .init(
                store: environment().store,
                network: environment().networks[.bitrise]!))

        let controller = Storyboard<BitriseDetailViewController>(name: "BitriseDetail").instantiate(dependency: .init(presenter: presenter))

        return controller
    }

    func settings(context: Settings.Context) -> UIViewController {
        let presenter = SettingsViewPresenter(
            dependency: .init(store: environment().store, networks: environment().networks, route: { [unowned self] from, event in
                switch event {
                case .detail(let ci):
                    let controller = self.ciSetting(context: .init(ci: ci))
                    from.navigationController?.pushViewController(controller, animated: true)
                }
            }))

        let controller = Storyboard<SettingsViewController>(name: "Settings").instantiate(dependency: .init(presenter: presenter))

        return controller
    }

    func ciSetting(context: CISetting.Context) -> UIViewController {
        let presenter = CISettingViewPresenter(
            .init(ci: context.ci),
            dependency: .init(
                interactor: CISettingInteractor(
                    store: environment().store,
                    fetchMeTravisCI: FetchMeFromTravisCI(network: environment().networks[.travisci]!),
                    fetchMeCircleCI: FetchMeFromCircleCI(network: environment().networks[.circleci]!),
                    fetchMeBitrise: FetchMeFromBitrise(network: environment().networks[.bitrise]!))))

        let controller = Storyboard<CISettingViewController>(name: "CISetting").instantiate(dependency: .init(presenter: presenter))

        return controller
    }
}
