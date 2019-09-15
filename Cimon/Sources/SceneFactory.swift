//
//  SceneFactory.swift
//  Cimon
//
//  Created by tawata-yu on 2019/09/13.
//

import Foundation
import UIKit
import Shared
import Bitrise
import CircleCI
import Core

final class SceneFactory: SceneFactoryProtocol {
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
