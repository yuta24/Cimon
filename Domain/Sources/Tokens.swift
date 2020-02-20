//
//  Tokens.swift
//  Domain
//
//  Created by Yu Tawata on 2019/05/04.
//

import Common
import Overture

public struct TravisCIToken: Codable {
    let token: Tagged<TravisCIToken, String>

    public var value: String {
        return token.rawValue
    }
}

public extension TravisCIToken {
    init(token: String) {
        self.token = .init(rawValue: token)
    }
}

public struct CircleCIToken: Codable {
    let token: Tagged<CircleCIToken, String>

    public var value: String {
        return token.rawValue
    }
}

public extension CircleCIToken {
    init(token: String) {
        self.token = .init(rawValue: token)
    }
}

public struct BitriseToken: Codable {
    let token: Tagged<BitriseToken, String>

    public var value: String {
        return token.rawValue
    }
}

public extension BitriseToken {
    init(token: String) {
        self.token = .init(rawValue: token)
    }
}
