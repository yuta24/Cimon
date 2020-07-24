//
//  DefaultAppInstalledStore.swift
//  Cimon
//
//  Created by Yu Tawata on 2020/07/08.
//

import Foundation
import Core

class DefaultAppInstalledStore: AppInstalledStore {
    private enum Constant {
        static let key = "app_installed"
    }

    private let userDefaults: UserDefaults

    init(userDefaults: UserDefaults) {
        self.userDefaults = userDefaults
    }

    func save(_ flag: Bool) {
        userDefaults.set(flag, forKey: Constant.key)
    }

    func load() -> Bool {
        userDefaults.bool(forKey: Constant.key)
    }
}
