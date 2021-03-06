import Foundation
import UIKit

public let mainSceneStyle = { (view: UIView) in
  switch view {
  case let view as UITableView:
    switch view.style {
    case .plain:
      view.backgroundColor = UIColor.systemBackground
    case .grouped:
      view.backgroundColor = UIColor.systemGroupedBackground
    case .insetGrouped:
      view.backgroundColor = UIColor.systemGroupedBackground
    @unknown default:
      view.backgroundColor = UIColor.systemBackground
    }
  default:
    view.backgroundColor = UIColor.systemBackground
  }
}

public let terminalStyle = { (view: UITextView) in
  view.backgroundColor = .black
  view.textColor = .white
  view.font = UIFont.monospacedSystemFont(ofSize: 14, weight: .regular)
  view.isEditable = false
}
