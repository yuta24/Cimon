//
//  SceneFactory.swift
//  Cimon
//
//  Created by tawata-yu on 2019/09/13.
//

import Foundation
import UIKit
import Shared
import TravisCI
import CircleCI
import Bitrise
import Core

final class SceneFactory: SceneFactoryProtocol {
    func travisCI(context: TravisCI.Context, with dependency: TravisCI.Dependency) -> UIViewController {
        let presenter = TravisCIViewPresenter(dependency: dependency)
        let controller = Storyboard<TravisCIViewController>(name: "TravisCI").instantiate(dependency: .init(presenter: presenter))
        return controller
    }

    func travisCIDetail(context: TravisCIDetail.Context, with dependency: TravisCIDetail.Dependency) -> UIViewController {
        let presenter = TravisCIDetailViewPresenter(.init(buildId: context.buildId), dependency: dependency)
        let controller = Storyboard<TravisCIDetailViewController>(name: "TravisCIDetail").instantiate(dependency: .init(network: dependency.network, store: dependency.store, presenter: presenter))
        return controller
    }

    func circleCI(context: CircleCI.Context, with dependency: CircleCI.Dependency) -> UIViewController {
        let presenter = CircleCIViewPresenter(dependency: dependency)
        let controller = Storyboard<CircleCIViewController>(name: "CircleCI").instantiate(dependency: .init(presenter: presenter))
        return controller
    }

    func bitrise(context: Bitrise.Context, with dependency: Bitrise.Dependency) -> UIViewController {
        let presenter = BitriseViewPresenter(dependency: dependency)
        let controller = Storyboard<BitriseViewController>(name: "Bitrise").instantiate(dependency: .init(presenter: presenter))
        return controller
    }

    func bitriseDetail(context: BitriseDetail.Context, with dependency: BitriseDetail.Dependency) -> UIViewController {
        let presenter = BitriseDetailViewPresenter(.init(appSlug: context.appSlug, buildSlug: context.buildSlug), dependency: dependency)
        let controller = Storyboard<BitriseDetailViewController>(name: "BitriseDetail").instantiate(dependency: .init(network: dependency.network, store: dependency.store, presenter: presenter))
        return controller
    }
}
