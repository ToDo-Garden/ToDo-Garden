import OnBoardingScene
import TDFoundation

import Foundation

@MainActor
public final class AppCore {
  public var dependency: Dependency
  
  public init(depdency: Dependency) {
    self.dependency = depdency
  }
  
  public func prepare() {
    if dependency.userDefaults.hasShownFirstLaunchOnboarding {
      //      dependency.userDefaults.setHasShownFirstLaunchOnboarding(false)
    } else {
      
    }
  }
}

extension AppCore {
  public struct Dependency: Sendable {
    let userDefaults: UserDefaultsClient = .live
  }
}
