//
//  Builds.swift
//  TravisCIAPI
//
//  Created by Yu Tawata on 2019/08/11.
//

import Foundation

// sourcery: public-initializer
public struct Builds: Codable {
  enum CodingKeys: String, CodingKey {
    case pagination = "@pagination"
    case builds = "builds"
  }

  public var pagination: Pagination
  public var builds: [Standard.Build]

  // sourcery:inline:Builds.Init
  // swiftlint:disable line_length
  public init(pagination: Pagination, builds: [Standard.Build]) {
    self.pagination = pagination
    self.builds = builds

  }
  // swiftlint:enabled line_length
  // sourcery:end
}
