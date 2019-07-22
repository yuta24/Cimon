//
//  CISetting.swift
//  App
//
//  Created by Yu Tawata on 2019/07/20.
//

import Foundation
import Shared
import Domain

enum CISettingScene {
    struct State {
        static var initial: State {
            return .init()
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

protocol CISettingViewPresenterProtocol {
    var state: CISettingScene.State { get }

    func subscribe(_ closure: @escaping (CISettingScene.State) -> Void)
    func unsubscribe()
    func dispatch(_ message: CISettingScene.Message) -> Reader<CISettingScene.Dependency, Void>

    func route(event: CISettingScene.Transition.Event) -> Reader<UIViewController, Void>
}

class CISettingViewPresenter: CISettingViewPresenterProtocol {
    private(set) var state: CISettingScene.State = .initial {
        didSet {
            DispatchQueue.main.async {
                self.closure?(self.state)
            }
        }
    }

    private var closure: ((CISettingScene.State) -> Void)?

    func subscribe(_ closure: @escaping (CISettingScene.State) -> Void) {
        self.closure = closure
        closure(state)
    }

    func unsubscribe() {
        self.closure = nil
    }

    func dispatch(_ message: CISettingScene.Message) -> Reader<CISettingScene.Dependency, Void> {
        return .init({ [weak self] (dependency) in
        })
    }

    func route(event: CISettingScene.Transition.Event) -> Reader<UIViewController, Void> {
        return .init({ (from) in
        })
    }
}
