//
//  AppInstalledStore.swift
//  Core
//
//  Created by Yu Tawata on 2020/07/08.
//

import Foundation

public protocol AppInstalledStore: AnyObject {
    func save(_ flag: Bool)
    func load() -> Bool
}
