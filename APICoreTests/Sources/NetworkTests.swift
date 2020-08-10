//
//  NetworkTests.swift
//  APICoreTests
//
//  Created by Yu Tawata on 2020/08/09.
//

import Combine
import XCTest
import Mocker
@testable import APICore

class NetworkTests: XCTestCase {
    struct Value: Decodable {
        var value: String
    }

    private let session: URLSession = {
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [MockingURLProtocol.self]
        return URLSession(configuration: configuration)
    }()

    let server = Server(baseURL: URL(string: "https://api.github.com")!)

    private var cancellables = Set<AnyCancellable>()

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        Mocker.removeAll()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testSuccess() throws {
        // Given
        Mock(
            url: URL(string: "https://api.github.com/zen?")!,
            dataType: .json,
            statusCode: 200,
            data: [.get : "{\"value\":\"abcd\"}".data(using: .utf8)!]
        )
        .register()

        let exp = expectation(description: #function)

        // When
        let request = CustomableRequest<Value>(
            method: .get,
            path: "/zen",
            headers: [:],
            queryParameters: [:],
            bodyParameters: [:]
        )

        // Then
        Network.shared.publisher(for: request, server: server)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    XCTFail(error.localizedDescription)
                case .finished:
                    break
                }
                exp.fulfill()
            } receiveValue: { value in
                XCTAssertEqual(value.0.value, "abcd")
            }
            .store(in: &cancellables)

        wait(for: [exp], timeout: 0.1)
    }

    func testFailure() throws {
        XCTContext.runActivity(named: "unacceptable") { _ in
            // Given
            Mock(
                url: URL(string: "https://api.github.com/zen?")!,
                dataType: .json,
                statusCode: 403,
                data: [.get : Data()]
            )
            .register()

            let exp = expectation(description: #function)

            // When
            let request = CustomableRequest<Value>(
                method: .get,
                path: "/zen",
                headers: [:],
                queryParameters: [:],
                bodyParameters: [:]
            )

            // Then
            Network.shared.publisher(for: request, server: server)
                .sink { completion in
                    switch completion {
                    case .failure(let error):
                        if case .unacceptable(let response) = error {
                            XCTAssertEqual(response.statusCode, 403)
                        }
                    case .finished:
                        break
                    }
                    exp.fulfill()
                } receiveValue: { _ in
                }
                .store(in: &cancellables)

            wait(for: [exp], timeout: 0.1)
        }

        XCTContext.runActivity(named: "decoding") { _ in
            // Given
            Mock(
                url: URL(string: "https://api.github.com/zen?")!,
                dataType: .json,
                statusCode: 200,
                data: [.get : "{\"v\":\"abcd\"}".data(using: .utf8)!]
            )
            .register()

            let exp = expectation(description: #function)

            // When
            let request = CustomableRequest<Value>(
                method: .get,
                path: "/zen",
                headers: [:],
                queryParameters: [:],
                bodyParameters: [:]
            )

            // Then
            Network.shared.publisher(for: request, server: server)
                .sink { completion in
                    switch completion {
                    case .failure(let error):
                        if case .decoding = error {
                        } else {
                            XCTFail(error.localizedDescription)
                        }
                    case .finished:
                        break
                    }
                    exp.fulfill()
                } receiveValue: { _ in
                }
                .store(in: &cancellables)

            wait(for: [exp], timeout: 0.1)
        }

        XCTContext.runActivity(named: "decoding") { _ in
            // Given
            Mock(
                url: URL(string: "https://api.github.com/zen?")!,
                dataType: .json,
                statusCode: 200,
                data: [.get : Data()],
                requestError: URLError(.timedOut)
            )
            .register()

            let exp = expectation(description: #function)

            // When
            let request = CustomableRequest<Value>(
                method: .get,
                path: "/zen",
                headers: [:],
                queryParameters: [:],
                bodyParameters: [:]
            )

            // Then
            Network.shared.publisher(for: request, server: server)
                .sink { completion in
                    switch completion {
                    case .failure(let error):
                        if case .url(let url) = error {
                            XCTAssertEqual(url.code, URLError.Code.timedOut)
                        }
                    case .finished:
                        break
                    }
                    exp.fulfill()
                } receiveValue: { _ in
                }
                .store(in: &cancellables)

            wait(for: [exp], timeout: 0.1)
        }
    }
}
