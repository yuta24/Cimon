//
//  OwnerAccountResponseModel.swift
//  BitriseAPI
//
//  Created by Yu Tawata on 2019/05/06.
//

import Foundation

public struct OwnerAccountResponseModel: Codable {
    enum CodingKeys: String, CodingKey {
        case accountType = "account_type"
        case name
        case slug
    }

    public var accountType: String?
    public var name: String?
    public var slug: String?

    public init(
        accountType: String?,
        name: String?,
        slug: String?) {
        self.accountType = accountType
        self.name = name
        self.slug = slug
    }
}
