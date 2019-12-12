import Foundation
import APIKit
import Combine

public protocol ClientProtocol: AnyObject {
  func response<R>(_ request: R) -> AnyPublisher<R.Response, SessionTaskError> where R: APIKit.Request
}
