//
//  UserProfileRespModel.swift
//  BitriseAPI
//
//  Created by Yu Tawata on 2019/07/22.
//

import Foundation

public struct UserProfileRespModel: Equatable, Codable {
    public var data: UserProfileDataModel?

    public init(data: UserProfileDataModel?) {
        self.data = data
    }
}
