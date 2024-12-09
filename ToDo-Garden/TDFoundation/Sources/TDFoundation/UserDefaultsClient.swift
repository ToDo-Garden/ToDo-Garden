import Foundation

extension UserDefaultsClient {
  public static let live: Self = {
    let defaults = { @Sendable in
      UserDefaults(suiteName: "group.isowords") ?? .standard
    }

    return Self(
      boolForKey: { defaults().bool(forKey: $0) },
      setBool: { defaults().set($0, forKey: $1) }
    )
  }()
}

public struct UserDefaultsClient: Sendable {
  public var boolForKey: @Sendable (String) -> Bool = { _ in false }
  public var setBool: @Sendable (Bool, String) async -> Void

  public var hasShownFirstLaunchOnboarding: Bool {
    self.boolForKey(hasShownFirstLaunchOnboardingKey)
  }
  
  public func setHasShownFirstLaunchOnboarding(_ bool: Bool) async {
    await self.setBool(bool, hasShownFirstLaunchOnboardingKey)
  }
}

let hasShownFirstLaunchOnboardingKey = "hasShownFirstLaunchOnboardingKey"
