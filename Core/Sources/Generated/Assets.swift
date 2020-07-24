// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

#if os(macOS)
  import AppKit
#elseif os(iOS)
  import UIKit
#elseif os(tvOS) || os(watchOS)
  import UIKit
#endif

// Deprecated typealiases
@available(*, deprecated, renamed: "ColorAsset.Color", message: "This typealias will be removed in SwiftGen 7.0")
public typealias AssetColorTypeAlias = ColorAsset.Color
@available(*, deprecated, renamed: "ImageAsset.Image", message: "This typealias will be removed in SwiftGen 7.0")
public typealias AssetImageTypeAlias = ImageAsset.Image

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Asset Catalogs

// swiftlint:disable identifier_name line_length nesting type_body_length type_name
public enum Asset {
  public static let accent = ColorAsset(name: "accent")
  public static let base00 = ColorAsset(name: "base00")
  public static let base01 = ColorAsset(name: "base01")
  public static let base02 = ColorAsset(name: "base02")
  public static let base03 = ColorAsset(name: "base03")
  public static let bitriseStatusAborted = ColorAsset(name: "bitrise_status_aborted")
  public static let bitriseStatusFailed = ColorAsset(name: "bitrise_status_failed")
  public static let bitriseStatusProgress = ColorAsset(name: "bitrise_status_progress")
  public static let bitriseStatusSuccess = ColorAsset(name: "bitrise_status_success")
  public static let circleciStatusAborted = ColorAsset(name: "circleci_status_aborted")
  public static let circleciStatusFailed = ColorAsset(name: "circleci_status_failed")
  public static let circleciStatusProgress = ColorAsset(name: "circleci_status_progress")
  public static let circleciStatusSuccess = ColorAsset(name: "circleci_status_success")
  public static let deleteFilled = ImageAsset(name: "delete-filled")
  public static let primary = ColorAsset(name: "primary")
  public static let settings = ImageAsset(name: "settings")
  public static let travisciStatusAborted = ColorAsset(name: "travisci_status_aborted")
  public static let travisciStatusFailed = ColorAsset(name: "travisci_status_failed")
  public static let travisciStatusProgress = ColorAsset(name: "travisci_status_progress")
  public static let travisciStatusSuccess = ColorAsset(name: "travisci_status_success")
}
// swiftlint:enable identifier_name line_length nesting type_body_length type_name

// MARK: - Implementation Details

public final class ColorAsset {
  public fileprivate(set) var name: String

  #if os(macOS)
  public typealias Color = NSColor
  #elseif os(iOS) || os(tvOS) || os(watchOS)
  public typealias Color = UIColor
  #endif

  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, macOS 10.13, *)
  public private(set) lazy var color: Color = Color(asset: self)

  fileprivate init(name: String) {
    self.name = name
  }
}

public extension ColorAsset.Color {
  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, macOS 10.13, *)
  convenience init!(asset: ColorAsset) {
    let bundle = BundleToken.bundle
    #if os(iOS) || os(tvOS)
    self.init(named: asset.name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    self.init(named: NSColor.Name(asset.name), bundle: bundle)
    #elseif os(watchOS)
    self.init(named: asset.name)
    #endif
  }
}

public struct ImageAsset {
  public fileprivate(set) var name: String

  #if os(macOS)
  public typealias Image = NSImage
  #elseif os(iOS) || os(tvOS) || os(watchOS)
  public typealias Image = UIImage
  #endif

  public var image: Image {
    let bundle = BundleToken.bundle
    #if os(iOS) || os(tvOS)
    let image = Image(named: name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    let image = bundle.image(forResource: NSImage.Name(name))
    #elseif os(watchOS)
    let image = Image(named: name)
    #endif
    guard let result = image else {
      fatalError("Unable to load image named \(name).")
    }
    return result
  }
}

public extension ImageAsset.Image {
  @available(macOS, deprecated,
    message: "This initializer is unsafe on macOS, please use the ImageAsset.image property")
  convenience init!(asset: ImageAsset) {
    #if os(iOS) || os(tvOS)
    let bundle = BundleToken.bundle
    self.init(named: asset.name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    self.init(named: NSImage.Name(asset.name))
    #elseif os(watchOS)
    self.init(named: asset.name)
    #endif
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    Bundle(for: BundleToken.self)
  }()
}
// swiftlint:enable convenience_type
