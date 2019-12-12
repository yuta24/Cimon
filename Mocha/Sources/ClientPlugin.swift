import Foundation

public protocol ClientPlugin {
    func prepare(urlRequest: URLRequest) -> URLRequest
    func willSend(urlRequest: URLRequest)
    func didReceive(object: Any, urlResponse: HTTPURLResponse)
}
