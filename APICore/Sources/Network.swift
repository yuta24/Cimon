//
//  Network.swift
//  APICore
//
//  Created by Yu Tawata on 2020/08/09.
//

import Foundation
import Combine

public enum NetworkError: Error {
    case url(URLError)
    case unacceptable(HTTPURLResponse)
    case decoding(DecodingError)
    case unknown(Error)
}

extension DecodingError.Context: Equatable {
    public static func == (lhs: DecodingError.Context, rhs: DecodingError.Context) -> Bool {
        return lhs.debugDescription == rhs.debugDescription
    }
}

extension DecodingError: Equatable {
    public static func ==(lhs: DecodingError, rhs: DecodingError) -> Bool {
        switch (lhs, rhs) {
        case (.typeMismatch(let lhsType, let lhsContext), .typeMismatch(let rhsType, let rhsContext)):
            return lhsType == rhsType && lhsContext == rhsContext
        case (.valueNotFound(let lhsType, let lhsContext), .valueNotFound(let rhsType, let rhsContext)):
            return lhsType == rhsType && lhsContext == rhsContext
        case (.keyNotFound(let lhsKey, let lhsContext), .keyNotFound(let rhsKey, let rhsContext)):
            return lhsKey.debugDescription == rhsKey.debugDescription && lhsContext == rhsContext
        case (.dataCorrupted(let lhsContext), .dataCorrupted(let rhsContext)):
            return lhsContext == rhsContext
        default:
            return false
        }
    }
}

extension NetworkError: Equatable {
    public static func == (lhs: NetworkError, rhs: NetworkError) -> Bool {
        switch (lhs, rhs) {
        case (.url(let lhsUrl), .url(let rhsUrl)):
            return lhsUrl == rhsUrl
        case (.unacceptable(let lhsResponse), .unacceptable(let rhsResponse)):
            return lhsResponse == rhsResponse
        case (.decoding(let lhsDecoding), .decoding(let rhsDecoding)):
            return lhsDecoding == rhsDecoding
        default:
            return false
        }
    }
}

public class Network: NSObject {
    public static let shared = Network(session: .shared)

    public let session: URLSession

    public init(session: URLSession) {
        self.session = session

        super.init()
    }
}

extension URLSession.DataTaskPublisher {
    func validate(_ range: Range<Int> = 200..<400) -> Publishers.TryMap<URLSession.DataTaskPublisher, (Data, HTTPURLResponse)> {
        return self.tryMap { data, response -> (Data, HTTPURLResponse) in
            guard let response = response as? HTTPURLResponse else {
                throw NetworkError.url(URLError(.unknown))
            }
            guard range.contains(response.statusCode) else {
                throw NetworkError.unacceptable(response)
            }

            return (data, response)
        }
    }
}

extension Network {
    public func publisher<R>(for request: R, server: Server) -> Publishers.MapError<Publishers.TryMap<URLSession.DataTaskPublisher, (R.Response, HTTPURLResponse)>, NetworkError> where R: Request {
        return session.dataTaskPublisher(for: server.requestBuild(request))
            .validate()
            .tryMap { data, response -> (R.Response, HTTPURLResponse) in
                do {
                    let object = try request.parse(data: data)
                    return (object, response)
                } catch let error as DecodingError {
                    throw NetworkError.decoding(error)
                } catch let error {
                    throw NetworkError.unknown(error)
                }
            }
            .mapError {
                switch $0 {
                case let error as URLError:
                    return NetworkError.url(error)
                case let error as NetworkError:
                    return error
                default:
                    return NetworkError.unknown($0)
                }
            }
    }
}
