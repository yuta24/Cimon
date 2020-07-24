//
//  ContinuousIntegration.swift
//  Domain
//
//  Created by Yu Tawata on 2019/05/04.
//

import Foundation

public enum ContinuousIntegration: CaseIterable {
    case travisci
    case circleci
    case bitrise
}

extension ContinuousIntegration: CustomStringConvertible {
    public var description: String {
        switch self {
        case .travisci:
            return "Travis CI"
        case .circleci:
            return "Circle CI"
        case .bitrise:
            return "Bitrise"
        }
    }
}
