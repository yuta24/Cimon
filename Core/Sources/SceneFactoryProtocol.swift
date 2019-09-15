//
//  SceneFactoryProtocol.swift
//  Core
//
//  Created by tawata-yu on 2019/09/13.
//

import Foundation
import UIKit
import Shared
import Domain

public enum Main {
    public struct Context {
        public var selected: CI
        public var pages: [(CI, UIViewController)]

        public init(selected: CI, pages: [(CI, UIViewController)]) {
            self.selected = selected
            self.pages = pages
        }
    }

    public enum Transition {
        public enum Event {
            case settings
        }
    }
}

public enum TravisCI {
    public struct Context {
        public static let none = Context()
    }

    public enum Transition {
        public enum Event {
            case detail(buildId: Int)
        }
    }
}

public enum TravisCIDetail {
    public struct Context {
        public var buildId: Int

        public init(buildId: Int) {
            self.buildId = buildId
        }
    }

    public enum Transition {
        public enum Event {
        }
    }
}

public enum CircleCI {
    public struct Context {
        public static let none = Context()
    }

    public enum Transition {
        public enum Event {
        }
    }
}

public enum Bitrise {
    public struct Context {
        public static let none = Context()
    }

    public enum Transition {
        public enum Event {
            case detail(repository: String, build: String)
        }
    }
}

public enum BitriseDetail {
    public struct Context {
        public var appSlug: String
        public var buildSlug: String

        public init(
            appSlug: String,
            buildSlug: String) {
            self.appSlug = appSlug
            self.buildSlug = buildSlug
        }
    }

    public enum Transition {
        public enum Event {
        }
    }
}

public enum Settings {
    public struct Context {
        public static let none = Context()
    }

    public enum Transition {
        public enum Event {
            case detail(CI)
        }
    }
}

public enum CISetting {
    public struct Context {
        public var ci: CI

        public init(ci: CI) {
            self.ci = ci
        }
    }

    public enum Transition {
        public enum Event {
        }
    }
}

public protocol SceneFactoryProtocol: class {
    func main(context: Main.Context) -> UIViewController
    func travisCI(context: TravisCI.Context) -> UIViewController
    func travisCIDetail(context: TravisCIDetail.Context) -> UIViewController
    func circleCI(context: CircleCI.Context) -> UIViewController
    func bitrise(context: Bitrise.Context) -> UIViewController
    func bitriseDetail(context: BitriseDetail.Context) -> UIViewController
    func settings(context: Settings.Context) -> UIViewController
    func ciSetting(context: CISetting.Context) -> UIViewController
}
