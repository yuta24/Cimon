//
//  Branch.swift
//  TravisCIAPI
//
//  Created by Yu Tawata on 2019/05/05.
//

import Foundation

extension Minimal {
  // sourcery: public-initializer
  public struct Branch: Codable {
    enum CodingKeys: String, CodingKey {
      case name
    }

    public var name: String

    // sourcery:inline:Minimal.Branch.Init
    // swiftlint:disable line_length
    public init(name: String) {
      self.name = name
    }
    // swiftlint:enabled line_length
    // sourcery:end
  }
}
