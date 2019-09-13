//
//  SceneFactoryProtocol.swift
//  Core
//
//  Created by tawata-yu on 2019/09/13.
//

import Foundation
import UIKit

public enum Settings {
    public struct Context {
        public static let none = Context()
    }
    public struct Dependency {
        public static let none = Context()
    }
}

public protocol SceneFactoryProtocol {
    func settings(_ context: Settings.Context, with dependency: Settings.Dependency) -> UIViewController
}
