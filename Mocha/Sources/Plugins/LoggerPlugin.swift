import Foundation

extension URLRequest {
    func cURLRepresentation() -> String {
        guard let url = self.url, /* let host = url.host, */ let method = self.httpMethod else {
            return "$ curl command could not be created"
        }

        var components = ["$ curl -v"]

        components.append("-X \(method)")

//        if let credentialStorage = delegate?.sessionConfiguration.urlCredentialStorage {
//            let protectionSpace = URLProtectionSpace(
//                host: host,
//                port: url.port ?? 0,
//                protocol: url.scheme,
//                realm: host,
//                authenticationMethod: NSURLAuthenticationMethodHTTPBasic
//            )
//
//            if let credentials = credentialStorage.credentials(for: protectionSpace)?.values {
//                for credential in credentials {
//                    guard let user = credential.user, let password = credential.password else { continue }
//                    components.append("-u \(user):\(password)")
//                }
//            } else {
//                if let credential = credential, let user = credential.user, let password = credential.password {
//                    components.append("-u \(user):\(password)")
//                }
//            }
//        }

//        if let configuration = delegate?.sessionConfiguration, configuration.httpShouldSetCookies {
//            if
//                let cookieStorage = configuration.httpCookieStorage,
//                let cookies = cookieStorage.cookies(for: url), !cookies.isEmpty
//            {
//                let allCookies = cookies.map { "\($0.name)=\($0.value)" }.joined(separator: ";")
//
//                components.append("-b \"\(allCookies)\"")
//            }
//        }

        var headers: [String: String] = [:]

//        if let additionalHeaders = delegate?.sessionConfiguration.httpAdditionalHeaders as? [String: String] {
//            for (field, value) in additionalHeaders where field != "Cookie" {
//                headers[field] = value
//            }
//        }

        if let headerFields = self.allHTTPHeaderFields {
            for (field, value) in headerFields where field != "Cookie" {
                headers[field] = value
            }
        }

        for (field, value) in headers {
            let escapedValue = value.replacingOccurrences(of: "\"", with: "\\\"")
            components.append("-H \"\(field): \(escapedValue)\"")
        }

        if let httpBodyData = self.httpBody, let httpBody = String(data: httpBodyData, encoding: .utf8) {
            var escapedBody = httpBody.replacingOccurrences(of: "\\\"", with: "\\\\\"")
            escapedBody = escapedBody.replacingOccurrences(of: "\"", with: "\\\"")

            components.append("-d \"\(escapedBody)\"")
        }

        components.append("\"\(url.absoluteString)\"")

        return components.joined(separator: " \\\n\t")
    }
}

public struct LoggerPlugin: ClientPlugin {
    let outputProvider: (String) -> Void

    public init(outputProvider: @escaping (String) -> Void) {
        self.outputProvider = outputProvider
    }

    public func prepare(urlRequest: URLRequest) -> URLRequest {
        return urlRequest
    }

    public func willSend(urlRequest: URLRequest) {
        outputProvider(urlRequest.cURLRepresentation())
    }

    public func didReceive(object: Any, urlResponse: HTTPURLResponse) {
        // no operation.
    }
}
