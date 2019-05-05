//
//  Bitrise.swift
//  App
//
//  Created by Yu Tawata on 2019/05/04.
//

import Foundation
import Promises
import Shared
import Domain

enum Bitrise {
    struct State {
        static var initial: State {
            return .init()
        }
    }

    enum Message {
    }

    enum Transition {
        enum Event {
        }
    }
}

protocol BitriseViewPresenterProtocol {
    var state: Bitrise.State { get }

    func subscribe(_ closure: @escaping (Bitrise.State) -> Void)
    func unsubscribe()
    func dispatch(_ message: Bitrise.Message)

    func route(event: Bitrise.Transition.Event) -> Reader<UIViewController, Void>
}

class BitriseViewPresenter: BitriseViewPresenterProtocol {
    private(set) var state: Bitrise.State = .initial {
        didSet {
            closure?(state)
        }
    }

    private var closure: ((Bitrise.State) -> Void)?

    func subscribe(_ closure: @escaping (Bitrise.State) -> Void) {
        self.closure = closure
        closure(state)
    }

    func unsubscribe() {
        self.closure = nil
    }

    func dispatch(_ message: Bitrise.Message) {
    }

    func route(event: Bitrise.Transition.Event) -> Reader<UIViewController, Void> {
        return .init({ (from) in
        })
    }
}
