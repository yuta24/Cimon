//
//  CustomableRequest.swift
//  APICoreTests
//
//  Created by Yu Tawata on 2020/08/09.
//

import Foundation
@testable import APICore

struct CustomableRequest<R>: Request where R: Decodable {
    typealias Response = R

    var method: APICore.Method
    var path: String
    var headers: [String : String]
    var queryParameters: [String : Any]
    var bodyParameters: [String : Any]

    func parse(data: Data) throws -> R {
        return try JSONDecoder().decode(R.self, from: data)
    }
}
