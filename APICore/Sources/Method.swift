//
//  Method.swift
//  APICore
//
//  Created by Yu Tawata on 2020/08/09.
//

import Foundation

public enum Method: String, CaseIterable {
    case get = "GET"
    case head = "HEAD"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
    case connect = "CONNECT"
    case options = "OPTIONS"
    case trace = "TRACE"
}
