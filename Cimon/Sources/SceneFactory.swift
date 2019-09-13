//
//  SceneFactory.swift
//  Cimon
//
//  Created by tawata-yu on 2019/09/13.
//

import Foundation
import UIKit
import Core

final class SceneFactory: SceneFactoryProtocol {
    func settings(_ context: Settings.Context, with dependency: Settings.Dependency) -> UIViewController {
        return UIViewController()
    }
}
