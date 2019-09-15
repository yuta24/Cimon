// Generated using Sourcery 0.16.1 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

import Foundation
import UIKit
import Shared

enum Scenes {

    static var ciSetting: Reader<CISettingViewController.Dependency, CISettingViewController> {
        return .init({ dependency in
            return Storyboard<CISettingViewController>(name: "CISetting")
                .instantiate(dependency: dependency)
         })
    }

    static var main: Reader<MainViewController.Dependency, MainViewController> {
        return .init({ dependency in
            return Storyboard<MainViewController>(name: "Main")
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
