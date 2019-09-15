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

public enum CircleCI {
    public struct Context {
        public static let none = Context()
    }

    public struct Dependency {
        public var fetchUseCase: FetchBuildsFromCircleCIProtocol
        public var store: StoreProtocol

        public init(
            fetchUseCase: FetchBuildsFromCircleCIProtocol,
            store: StoreProtocol) {
            self.fetchUseCase = fetchUseCase
            self.store = store
        }
    }
}

public enum Bitrise {
    public struct Context {
        public static let none = Context()
    }

    public struct Dependency {
        public var fetchUseCase: FetchBuildsFromBitriseProtocol
        public var store: StoreProtocol
        public var network: NetworkServiceProtocol
        public var sceneFactory: SceneFactoryProtocol

        public init(
            fetchUseCase: FetchBuildsFromBitriseProtocol,
            store: StoreProtocol,
            network: NetworkServiceProtocol,
            sceneFactory: SceneFactoryProtocol) {
            self.fetchUseCase = fetchUseCase
            self.store = store
            self.network = network
            self.sceneFactory = sceneFactory
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

    public struct Dependency {
        public var store: StoreProtocol
        public var network: NetworkServiceProtocol

        public init(
            store: StoreProtocol,
            network: NetworkServiceProtocol) {
            self.store = store
            self.network = network
        }
    }
}

public protocol SceneFactoryProtocol: class {
    func circleCI(context: CircleCI.Context, with dependency: CircleCI.Dependency) -> UIViewController
    func bitrise(context: Bitrise.Context, with dependency: Bitrise.Dependency) -> UIViewController
    func bitriseDetail(context: BitriseDetail.Context, with dependency: BitriseDetail.Dependency) -> UIViewController
}
