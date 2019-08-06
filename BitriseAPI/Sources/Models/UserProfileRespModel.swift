//
//  UserProfileRespModel.swift
//  BitriseAPI
//
//  Created by Yu Tawata on 2019/07/22.
//

import Foundation

// sourcery: public-initializer
public struct UserProfileRespModel: Codable {
    enum CodingKeys: String, CodingKey {
        case data
    }

    public var data: UserProfileDataModel?

    // sourcery:inline:UserProfileRespModel.Init
    // swiftlint:disable line_length
    public init(data: UserProfileDataModel?) {
        self.data = data

    }
    // swiftlint:enabled line_length
    // sourcery:end
}
