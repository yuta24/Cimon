import Domain

public extension StorageKey {
  static var travisCIToken: StorageKey<TravisCIToken> {
    return .init(rawValue: "travis_ci:token")
  }
  static var circleCIToken: StorageKey<CircleCIToken> {
    return .init(rawValue: "circle_ci:token")
  }
  static var bitriseToken: StorageKey<BitriseToken> {
    return .init(rawValue: "bitrise:token")
  }
}
