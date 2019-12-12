import Foundation
import APIKit
import Combine

struct RequestSubscription: Subscription {
  let combineIdentifier: CombineIdentifier
  let task: URLSessionTask

  func request(_ demand: Subscribers.Demand) {}

  func cancel() {
    task.cancel()
  }
}

struct RequestPublisher<Request>: Publisher where Request: APIKit.Request {
  typealias Output = Request.Response
  typealias Failure = SessionTaskError

  let session: URLSession
  let request: Request

  func receive<S>(subscriber: S) where S: Subscriber, Failure == S.Failure, Output == S.Input {
    let task = session.dataTask(with: try! request.buildURLRequest()) { data, response, error in
      guard error == nil else {
        return
      }

      if let response = response as? HTTPURLResponse, let data = data {
        switch response.statusCode {
        case 100...199:
          break
        case 200...299:
          switch Request.Response.self {
          case is String.Type:
          case is Void.Type:
          case let decodable as Decodable.Type:
          default:
            break
          }
        default:
          break
        }
      }
    }
//        let task = session.send(request) { (result) in
//            switch result {
//            case .success(let response):
//                _ = subscriber.receive(response)
//                subscriber.receive(completion: .finished)
//            case .failure(let error):
//                subscriber.receive(completion: .failure(error))
//            }
//        }

        let subscription = RequestSubscription(combineIdentifier: CombineIdentifier(), task: task)
        subscriber.receive(subscription: subscription)

    task.resume()
  }
}

open class Client: ClientProtocol {
  let session: URLSession
  var plugins: [ClientPlugin]

  public init(session: URLSession, plugins: [ClientPlugin] = []) {
      self.session = session
      self.plugins = plugins
  }

  open func response<R>(_ request: R) -> AnyPublisher<R.Response, SessionTaskError> where R: APIKit.Request {
  }
}
