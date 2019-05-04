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
    static func main() -> Reader<MainViewController.Dependency, MainViewController> {
        return .init({ dependency in
            return Storyboard<MainViewController>(bundle: .current, name: "Main").instantiate(dependency: dependency)
        })
    }
}
