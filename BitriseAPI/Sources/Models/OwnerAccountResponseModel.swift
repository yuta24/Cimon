//
//  OwnerAccountResponseModel.swift
//  BitriseAPI
//
//  Created by Yu Tawata on 2019/05/06.
//

import Foundation

// sourcery: public-initializer
public struct OwnerAccountResponseModel: Codable {
    enum CodingKeys: String, CodingKey {
        case accountType = "account_type"
        case name
        case slug
    }

    public var accountType: String?
    public var name: String?
    public var slug: String?

    // sourcery:inline:OwnerAccountResponseModel.Init
    // swiftlint:disable line_length
    public init(accountType: String?, name: String?, slug: String?) {
        self.accountType = accountType
        self.name = name
        self.slug = slug

    }
    // swiftlint:enabled line_length
    // sourcery:end
}
