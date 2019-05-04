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
            return Storyboard<MainViewController>(bundle: .current, name: "Main")
                .instantiate(dependency: dependency)
        })
    }

    static var travisCI: Reader<TravisCIViewController.Dependency, TravisCIViewController> {
        return .init({ dependency in
            return Storyboard<TravisCIViewController>(bundle: .current, name: "TravisCI")
                .instantiate(dependency: dependency)
        })
    }

    static var circleCI: Reader<CircleCIViewController.Dependency, CircleCIViewController> {
        return .init({ dependency in
            return Storyboard<CircleCIViewController>(bundle: .current, name: "CircleCI")
                .instantiate(dependency: dependency)
        })
    }

    static var bitrise: Reader<BitriseViewController.Dependency, BitriseViewController> {
        return .init({ dependency in
            return Storyboard<BitriseViewController>(bundle: .current, name: "Bitrise")
                .instantiate(dependency: dependency)
        })
    }
}
