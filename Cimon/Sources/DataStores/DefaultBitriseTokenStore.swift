//
//  DefaultBitriseTokenStore.swift
//  Cimon
//
//  Created by Yu Tawata on 2020/07/08.
//

import Foundation
import KeychainAccess
import Domain
import Core

class DefaultBitriseTokenStore: BitriseTokenStore {
    private enum Constant {
        static let key = "bitrise"
    }

    private let keychain: Keychain

    init(keychain: Keychain) {
        self.keychain = keychain
    }

    func save(_ token: BitriseToken) {
        try? keychain.set(token.value, key: Constant.key)
    }

    func load() -> BitriseToken? {
        let raw = try? keychain.get(Constant.key)
        return raw.flatMap(BitriseToken.init)
    }

    func remove() {
        try? keychain.remove(Constant.key)
    }
}
