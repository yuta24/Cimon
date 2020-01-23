//
//  Configurable.swift
//  Shared
//
//  Created by Yu Tawata on 2019/05/11.
//

import Foundation

public protocol Configurable {
    associatedtype Context

    func configure(_ context: Context)
}
