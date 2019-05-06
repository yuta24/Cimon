//
//  Branch.swift
//  TravisCIAPI
//
//  Created by Yu Tawata on 2019/05/05.
//

import Foundation

public struct Branch: Codable {
    enum CodingKeys: String, CodingKey {
        case name = "name"
    }

    public var name: String

    public init(name: String) {
        self.name = name
    }
}
