//
//  CircleCI.swift
//  App
//
//  Created by Yu Tawata on 2019/05/04.
//

import Foundation
import Promises
import Shared
import Domain

enum CircleCI {
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

protocol CircleCIViewPresenterProtocol {
    var state: CircleCI.State { get }

    func subscribe(_ closure: @escaping (CircleCI.State) -> Void)
    func unsubscribe()
    func dispatch(_ message: CircleCI.Message)

    func route(event: CircleCI.Transition.Event) -> Reader<UIViewController, Void>
}

class CircleCIViewPresenter: CircleCIViewPresenterProtocol {
    private(set) var state: CircleCI.State = .initial {
        didSet {
            closure?(state)
        }
    }

    private var closure: ((CircleCI.State) -> Void)?

    func subscribe(_ closure: @escaping (CircleCI.State) -> Void) {
        self.closure = closure
        closure(state)
    }

    func unsubscribe() {
        self.closure = nil
    }

    func dispatch(_ message: CircleCI.Message) {
    }

    func route(event: CircleCI.Transition.Event) -> Reader<UIViewController, Void> {
        return .init({ (from) in
        })
    }
}
