//
//  Scenes.swift
//  App
//
//  Created by Yu Tawata on 2019/05/04.
//

import Foundation
import UIKit
import Shared

enum Scenes {
    static var main: Reader<MainViewController.Dependency, MainViewController> {
        return .init({ dependency in
            return Storyboard<MainViewController>(name: "Main")
                .instantiate(dependency: dependency)
        })
    }

    static var travisCI: Reader<TravisCIViewController.Dependency, TravisCIViewController> {
        return .init({ dependency in
            return Storyboard<TravisCIViewController>(name: "TravisCI")
                .instantiate(dependency: dependency)
        })
    }

    static var circleCI: Reader<CircleCIViewController.Dependency, CircleCIViewController> {
        return .init({ dependency in
            return Storyboard<CircleCIViewController>(name: "CircleCI")
                .instantiate(dependency: dependency)
        })
    }

    static var bitrise: Reader<BitriseViewController.Dependency, BitriseViewController> {
        return .init({ dependency in
            return Storyboard<BitriseViewController>(name: "Bitrise")
                .instantiate(dependency: dependency)
        })
    }

    static var bitriseDetail: Reader<BitriseDetailViewController.Dependency, BitriseDetailViewController> {
        return .init({ dependency in
            return Storyboard<BitriseDetailViewController>(name: "BitriseDetail")
                .instantiate(dependency: dependency)
        })
    }

    static var settings: Reader<SettingsViewController.Dependency, SettingsViewController> {
        return .init({ dependency in
            return Storyboard<SettingsViewController>(name: "Settings")
                .instantiate(dependency: dependency)
        })
    }
}
