import Foundation

import HTTPClient
import OnBoardingScene
import TDFoundation

@MainActor
public final class AppCore {
  public var dependency: Dependency
  public enum Destination {
    case none
    
    case onboarding
    case tutorial
    case login((Bool, Bool) -> Destination)
    case signUp(Bool)
    
    case home
  }
  var destination: Destination {
    didSet {
      self.dependency.router.switchTo(self.destination)
    }
  }
  
  public init(dependency: Dependency) {
    self.dependency = dependency
    self.destination = .none
  }
  
  // MARK: 앱시작시 무조건 먼저 호출해야하는 메소드
  public func getStarted() {
    if !self.dependency.userDefaults.hasShownFirstLaunchOnboarding {
      self.destination = Destination.onboarding
      Task {
        await self.dependency.userDefaults.setHasShownFirstLaunchOnboarding(true)
      }
    } else {
      Task {
        let isLoggedIn = false
        self.destination = isLoggedIn
        ? Destination.home
        : Destination.login { $0 ? Destination.home : Destination.signUp($1) }
      }
    }
  }
}

extension AppCore {
  public struct Dependency {
    @MainActor
    public static let live: Dependency = {
      let httpClient = HTTPClient.live
      
      return Dependency(
        userDefaults: UserDefaultsClient.live,
        router: AppRouter(httpClient: httpClient),
        httpClient: httpClient
      )
    }()
    public let userDefaults: UserDefaultsClient
    public let router: AppRouter
    public let httpClient: HTTPClient
  }
}

#if DEBUG
import UIKit
@available(iOS 17.0, *)
#Preview {
  let core = AppCore(dependency: .live)
  core.destination = .login {
    $0 ? .home : .signUp($1)
  }
  return core.dependency.router.navigationController
}
#endif
