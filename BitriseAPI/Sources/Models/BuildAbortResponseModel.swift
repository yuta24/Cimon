//
//  BuildAbortResponseModel.swift
//  BitriseAPI
//
//  Created by Yu Tawata on 2020/07/22.
//

import Foundation

public struct BuildAbortResponseModel: Equatable, Codable {
    public var status: String

    public init(status: String) {
        self.status = status
    }
}
