import Foundation
import UIKit

@IBDesignable
open class RoundedView: UIView {
  @IBInspectable
  public var cornerRadius: CGFloat {
    get {
      return layer.cornerRadius
    }
    set {
      layer.cornerRadius = newValue
      layer.masksToBounds = true
    }
  }

  @IBInspectable
  public var borderColor: UIColor? {
    get {
      return layer.borderColor.flatMap(UIColor.init)
    }
    set {
      layer.borderColor = newValue?.cgColor
      layer.masksToBounds = true
    }
  }

  @IBInspectable
  public var borderWidth: CGFloat {
    get {
      return layer.borderWidth
    }
    set {
      layer.borderWidth = newValue
      layer.masksToBounds = true
    }
  }

  @IBInspectable
  public var shadowColor: UIColor? {
    get {
      return layer.shadowColor.flatMap(UIColor.init)
    }
    set {
      layer.shadowColor = newValue?.cgColor
    }
  }

  @IBInspectable
  public var shadowOpacity: Float {
    get {
      return layer.shadowOpacity
    }
    set {
      layer.shadowOpacity = newValue
    }
  }

  @IBInspectable
  public var shadowOffset: CGSize {
    get {
      return layer.shadowOffset
    }
    set {
      layer.shadowOffset = newValue
    }
  }

  @IBInspectable
  public var shadowRadius: CGFloat {
    get {
      return layer.shadowRadius
    }
    set {
      layer.shadowRadius = newValue
    }
  }

  open override func draw(_ rect: CGRect) {
    layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: layer.shadowRadius).cgPath
    super.draw(rect)
  }
}
