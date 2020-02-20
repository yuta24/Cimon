import UIKit
import Common
import Domain
import Core

public class App {
  public private(set) var window: UIWindow!
  public let sceneAseembler: SceneAseemblerProtocol

  public init(env: Env) {
    self.sceneAseembler = SceneAseembler { env }
  }

  public func configure(window: UIWindow) {
    self.window = window

    let mainViewController = sceneAseembler.main(
      context: .init(
        selected: .travisci,
        pages: { () -> [(CI, UIViewController)] in
          let travisCIController = sceneAseembler.travisCI(context: .none)
          let circleCIController = sceneAseembler.circleCI(context: .none)
          let bitriseController = sceneAseembler.bitrise(context: .none)

          return [
            (.travisci, travisCIController),
            (.circleci, circleCIController),
            (.bitrise, bitriseController)]
      }()))

    apply(window, {
      $0.rootViewController = UINavigationController(rootViewController: mainViewController)
      $0.makeKeyAndVisible()
    })
  }

  public func willConnect(to session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
  }

  public func didDisconnect() {
  }

  public func didBecomeActive() {
  }

  public func willResignActive() {
  }

  public func willEnterForeground() {
  }

  public func didEnterBackground() {
  }
}
