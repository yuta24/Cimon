import Foundation
import Mocha
import Domain

public class Dependency {
  public let store: StoreProtocol
  public let clients: [CI: Client]
  public let reporter: ReporterProtocol

  public init(store: StoreProtocol, clients: [CI: Client], reporter: ReporterProtocol) {
    self.store = store
    self.clients = clients
    self.reporter = reporter
  }
}
