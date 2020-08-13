//
//  Result+Extension.swift
//  Litey
//
//  Created by Yu Tawata on 2020/08/13.
//

import Foundation

extension Result {
    public var value: Success? {
        if case .success(let value) = self {
            return value
        } else {
            return .none
        }
    }

    public var error: Failure? {
        if case .failure(let error) = self {
            return error
        } else {
            return .none
        }
    }
}
