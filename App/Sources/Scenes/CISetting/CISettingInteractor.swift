//
//  CISettingInteractor.swift
//  App
//
//  Created by Yu Tawata on 2019/07/24.
//

import Foundation
import APIKit
import ReactiveSwift
import Shared
import Domain

protocol CISettingInteractorProtocol {
    func fetchToken(_ ci: CI) -> String?
    func fetchMe(_ ci: CI) -> SignalProducer<(name: String?, avatarUrl: URL?), SessionTaskError>
    func authorize(_ ci: CI, token: String) -> SignalProducer<(name: String?, avatarUrl: URL?), SessionTaskError>
    func deauthorize(_ ci: CI) -> SignalProducer<Void, Never>
}

class CISettingInteractor: CISettingInteractorProtocol {
    private let store: StoreProtocol
    private let fetchMeTravisCI: FetchMeFromTravisCIProtocol
    private let fetchMeCircleCI: FetchMeFromCircleCIProtocol
    private let fetchMeBitrise: FetchMeFromBitriseProtocol

    init(
        store: StoreProtocol,

        fetchMeTravisCI: FetchMeFromTravisCIProtocol,
        fetchMeCircleCI: FetchMeFromCircleCIProtocol,
        fetchMeBitrise: FetchMeFromBitriseProtocol) {
        self.store = store
        self.fetchMeTravisCI = fetchMeTravisCI
        self.fetchMeCircleCI = fetchMeCircleCI
        self.fetchMeBitrise = fetchMeBitrise
    }

    func fetchToken(_ ci: CI) -> String? {
        switch ci {
        case .travisci:
            return store.value(.travisCIToken)?.value
        case .circleci:
            return store.value(.circleCIToken)?.value
        case .bitrise:
            return store.value(.bitriseToken)?.value
        }
    }

    func fetchMe(_ ci: CI) -> SignalProducer<(name: String?, avatarUrl: URL?), SessionTaskError> {
        switch ci {
        case .travisci:
            return fetchMeTravisCI.run()
                .map { (response) in
                    return (response.name, URL(string: response.avatarUrlString))
                }
        case .circleci:
            return fetchMeCircleCI.run()
                .map { (response) in
                    return (response.name, URL(string: response.avatarUrlString))
                }
        case .bitrise:
            return fetchMeBitrise.run()
                .map { (response) in
                    return (response.data?.username, response.data?.avatarUrlString.flatMap(URL.init))
                }
        }
    }

    func authorize(_ ci: CI, token: String) -> SignalProducer<(name: String?, avatarUrl: URL?), SessionTaskError> {
        return SignalProducer<Void, Never>.init({ [weak self] (observer, lifetime) in
            switch ci {
            case .travisci:
                self?.store.set(TravisCIToken(token: token), for: .travisCIToken)
            case .circleci:
                self?.store.set(CircleCIToken(token: token), for: .circleCIToken)
            case .bitrise:
                self?.store.set(BitriseToken(token: token), for: .bitriseToken)
            }

            observer.send(value: ())

            lifetime.observeEnded {
                // no operation
            }
        })
        .flatMap(.concat) { [unowned self] (_) in
            self.fetchMe(ci)
        }
    }

    func deauthorize(_ ci: CI) -> SignalProducer<Void, Never> {
        return SignalProducer<Void, Never>.init({ [weak self] (observer, lifetime) in
            switch ci {
            case .travisci:
                self?.store.set(nil, for: .travisCIToken)
            case .circleci:
                self?.store.set(nil, for: .circleCIToken)
            case .bitrise:
                self?.store.set(nil, for: .bitriseToken)
            }

            observer.send(value: ())

            lifetime.observeEnded {
                // no operation
            }
        })
    }
}
