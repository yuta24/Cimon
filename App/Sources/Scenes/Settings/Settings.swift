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
        var travisCIToken: TravisCIToken!
        var circleCIToken: CircleCIToken!
        var bitriseToken: BitriseToken!
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
    }

    enum Transition {
        enum Event {
        }
    }
}

protocol SettingsViewPresenterProtocol {
    var state: SettingsScene.State { get }

    func subscribe(_ closure: @escaping (SettingsScene.State) -> Void)
    func unsubscribe()
    func dispatch(_ message: SettingsScene.Message) -> Reader<SettingsScene.Dependency, Void>

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

    func subscribe(_ closure: @escaping (SettingsScene.State) -> Void) {
        self.closure = closure
        closure(state)
    }

    func unsubscribe() {
        self.closure = nil
    }

    func dispatch(_ message: SettingsScene.Message) -> Reader<SettingsScene.Dependency, Void> {
        return .init({ [weak self] (dependency) in
            switch message {
            case .load:
                self?.state.travisCIToken = dependency.store.value(.travisCIToken)
                self?.state.circleCIToken = dependency.store.value(.circleCIToken)
                self?.state.bitriseToken = dependency.store.value(.bitriseToken)
            }
        })
    }

    func route(event: SettingsScene.Transition.Event) -> Reader<UIViewController, Void> {
        return .init({ (from) in
        })
    }
}
