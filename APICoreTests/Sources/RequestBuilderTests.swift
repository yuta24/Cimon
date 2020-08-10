//
//  RequestBuilderTests.swift
//  APICoreTests
//
//  Created by Yu Tawata on 2020/08/09.
//

import XCTest
@testable import APICore

class RequestBuilderTests: XCTestCase {
    let builder = RequestBuilder()

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testMethods() throws {
        for method in APICore.Method.allCases {
            // Given
            let request = CustomableRequest<Int>(
                method: method,
                path: "/zen",
                headers: [:],
                queryParameters: [:],
                bodyParameters: [:]
            )

            // When
            let urlRequest = builder.build(request, with: URL(string: "https://api.github.com")!)

            // Then
            XCTAssertEqual(urlRequest.httpMethod, method.rawValue)
        }
    }

    func testHeaders() throws {
        // Given
        let request = CustomableRequest<Int>(
            method: .get,
            path: "/zen",
            headers: [
                "Content-Type": "application/json; charset=utf-8"
            ],
            queryParameters: [:],
            bodyParameters: [:]
        )

        // When
        let urlRequest = builder.build(request, with: URL(string: "https://api.github.com")!)

        // Then
        XCTAssertEqual(urlRequest.value(forHTTPHeaderField: "Content-Type"), "application/json; charset=utf-8")
    }

    func testQueryParameters() throws {
        XCTContext.runActivity(named: "No query") { _ in
            // Given
            let request = CustomableRequest<Int>(
                method: .get,
                path: "/zen",
                headers: [
                    "Content-Type": "application/json; charset=utf-8"
                ],
                queryParameters: [:],
                bodyParameters: [:]
            )

            // When
            let urlRequest = builder.build(request, with: URL(string: "https://api.github.com")!)

            // Then
            XCTAssertTrue(urlRequest.url!.query!.isEmpty)
        }

        XCTContext.runActivity(named: "Have query") { _ in
            XCTContext.runActivity(named: "value") { _ in
                // Given
                let request = CustomableRequest<Int>(
                    method: .get,
                    path: "/zen",
                    headers: [
                        "Content-Type": "application/json; charset=utf-8"
                    ],
                    queryParameters: [
                        "value": "abcdefg",
                    ],
                    bodyParameters: [:]
                )

                // When
                let urlRequest = builder.build(request, with: URL(string: "https://api.github.com")!)

                // Then
                XCTAssertEqual(urlRequest.url?.query, "value=abcdefg")
            }

            XCTContext.runActivity(named: "values") { _ in
                // Given
                let request = CustomableRequest<Int>(
                    method: .get,
                    path: "/zen",
                    headers: [
                        "Content-Type": "application/json; charset=utf-8"
                    ],
                    queryParameters: [
                        "values": [1, 2, 3]
                    ],
                    bodyParameters: [:]
                )

                // When
                let urlRequest = builder.build(request, with: URL(string: "https://api.github.com")!)

                // Then
                XCTAssertEqual(urlRequest.url?.query, "values=1&values=2&values=3")
            }
        }
    }

    func testBodyParameters() throws {
        XCTContext.runActivity(named: "No body") { _ in
            // Given
            let request = CustomableRequest<Int>(
                method: .get,
                path: "/zen",
                headers: [:],
                queryParameters: [:],
                bodyParameters: [:]
            )

            // When
            let urlRequest = builder.build(request, with: URL(string: "https://api.github.com")!)

            // Then
            XCTAssertNil(urlRequest.httpBody)
        }

        XCTContext.runActivity(named: "Have body") { _ in
            XCTContext.runActivity(named: "value") { _ in
                // Given
                let request = CustomableRequest<Int>(
                    method: .get,
                    path: "/zen",
                    headers: [
                        "Content-Type": "application/json; charset=utf-8"
                    ],
                    queryParameters: [:],
                    bodyParameters: [
                        "value": "abcdefg",
                    ]
                )

                // When
                let urlRequest = builder.build(request, with: URL(string: "https://api.github.com")!)
                let decode = try! JSONDecoder().decode([String: String].self, from: urlRequest.httpBody!)

                // Then
                XCTAssertEqual(decode, ["value":"abcdefg"])
            }

            XCTContext.runActivity(named: "values") { _ in
                // Given
                let request = CustomableRequest<Int>(
                    method: .get,
                    path: "/zen",
                    headers: [
                        "Content-Type": "application/json; charset=utf-8"
                    ],
                    queryParameters: [:],
                    bodyParameters: [
                        "values": [1, 2, 3]
                    ]
                )

                // When
                let urlRequest = builder.build(request, with: URL(string: "https://api.github.com")!)
                let decode = try! JSONDecoder().decode([String: [Int]].self, from: urlRequest.httpBody!)

                // Then
                XCTAssertEqual(decode, ["values": [1, 2, 3]])
            }
        }
    }

}
