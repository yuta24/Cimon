//
//  TravisCI.swift
//  App
//
//  Created by Yu Tawata on 2019/05/04.
//

import Foundation
import Promises
import Shared
import Domain

enum TravisCI {
    struct State {
        static var initial: State {
            return .init()
        }
    }

    enum Message {
    }

    enum TransitionEvent {
    }
}

protocol TravisCIViewPresenterProtocol {
    var state: TravisCI.State { get }

    func subscribe(_ closure: @escaping (TravisCI.State) -> Void)
    func unsubscribe()
    func dispatch(_ message: TravisCI.Message)

    func route(event: TravisCI.TransitionEvent) -> Reader<UIViewController, Void>
}

class TravisCIViewPresenter: TravisCIViewPresenterProtocol {
    private(set) var state: TravisCI.State = .initial

    private var closure: ((TravisCI.State) -> Void)?

    func subscribe(_ closure: @escaping (TravisCI.State) -> Void) {
        self.closure = closure
    }

    func unsubscribe() {
        self.closure = nil
    }

    func dispatch(_ message: TravisCI.Message) {
    }

    func route(event: TravisCI.TransitionEvent) -> Reader<UIViewController, Void> {
        return .init({ (from) in
        })
    }
}
