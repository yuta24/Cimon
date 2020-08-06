//
//  ContinuousIntegration.swift
//  Domain
//
//  Created by Yu Tawata on 2019/05/04.
//

import Foundation

public enum ContinuousIntegration: Identifiable, CaseIterable {
    case bitrise
    case github

    public var id: Self { self }
}

extension ContinuousIntegration: CustomStringConvertible {
    public var description: String {
        switch self {
        case .bitrise:
            return "Bitrise"
        case .github:
            return "GitHub Actions"
        }
    }
}
