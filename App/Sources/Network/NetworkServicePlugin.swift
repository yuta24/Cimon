//
//  NetworkServicePlugin.swift
//  App
//
//  Created by Yu Tawata on 2019/05/06.
//

import Foundation
import APIKit

protocol NetworkServicePlugin {
    func prepare(urlRequest: URLRequest) -> URLRequest
    func willSend(urlRequest: URLRequest)
    func didReceive(object: Any, urlResponse: HTTPURLResponse)
}
