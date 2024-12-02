import OnBoardingScene
import TDFoundation

import Foundation

@MainActor
public final class AppCore {
  public var dependency: Dependency
  
  public init(depdency: Dependency) {
    self.dependency = depdency
  }
  
  public func getStarted() {
    if !dependency.userDefaults.hasShownFirstLaunchOnboarding {
      dependency.router.switchTo(.onboarding)
      Task {
        await dependency.userDefaults.setHasShownFirstLaunchOnboarding(false)
      }
    } else {
      dependency.router.switchTo(.home)
    }
  }
}

extension AppCore {
  public struct Dependency {
    @MainActor
    public static let live = Dependency(
      userDefaults: UserDefaultsClient.live,
      router: AppRouter()
    )
    public let userDefaults: UserDefaultsClient
    public let router: AppRouter
  }
}
