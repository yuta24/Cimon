//
//  Settings.swift
//  App
//
//  Created by Yu Tawata on 2019/07/13.
//

import Foundation
import Shared
import Domain

enum SettingsScene {
    struct State {
        var travisCIToken: TravisCIToken?
        var circleCIToken: CircleCIToken?
        var bitriseToken: BitriseToken?
        var version: String

        static var initial: State {
            return .init(
                travisCIToken: nil,
                circleCIToken: nil,
                bitriseToken: nil,
                version: "\(UIDevice.shortVersion)(\(UIDevice.buildVersion))")
        }
    }

    enum Message {
        case load
    }

    struct Dependency {
        var store: StoreProtocol
        var networks: [CI: NetworkServiceProtocol]
    }

    enum Transition {
        enum Event {
            case detail(CI)
        }
    }
}

protocol SettingsViewPresenterProtocol {
    var state: SettingsScene.State { get }

    func subscribe(_ closure: @escaping (SettingsScene.State) -> Void)
    func unsubscribe()
    func dispatch(_ message: SettingsScene.Message)

    func route(event: SettingsScene.Transition.Event) -> Reader<UIViewController, Void>
}

class SettingsViewPresenter: SettingsViewPresenterProtocol {
    private(set) var state: SettingsScene.State = .initial {
        didSet {
            DispatchQueue.main.async {
                self.closure?(self.state)
            }
        }
    }

    private var closure: ((SettingsScene.State) -> Void)?

    private let dependency: SettingsScene.Dependency

    init(dependency: SettingsScene.Dependency) {
        self.dependency = dependency
    }

    func subscribe(_ closure: @escaping (SettingsScene.State) -> Void) {
        self.closure = closure
        closure(state)
    }

    func unsubscribe() {
        self.closure = nil
    }

    func dispatch(_ message: SettingsScene.Message) {
        switch message {
        case .load:
            state.travisCIToken = dependency.store.value(.travisCIToken)
            state.circleCIToken = dependency.store.value(.circleCIToken)
            state.bitriseToken = dependency.store.value(.bitriseToken)
        }
    }

    func route(event: SettingsScene.Transition.Event) -> Reader<UIViewController, Void> {
        return .init({ (from) in
            switch event {
            case .detail(let ci):
                let interactor = CISettingInteractor(
                    store: self.dependency.store,
                    fetchMeTravisCI: FetchMeFromTravisCI(network: self.dependency.networks[.travisci]!),
                    fetchMeCircleCI: FetchMeFromCircleCI(network: self.dependency.networks[.circleci]!),
                    fetchMeBitrise: FetchMeFromBitrise(network: self.dependency.networks[.bitrise]!))
                let controller = Scenes.ciSetting.execute(.init(presenter: CISettingViewPresenter(ci: ci, dependency: .init(interactor: interactor))))
                from.navigationController?.pushViewController(controller, animated: true)
            }
        })
    }
}
