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
    case login
    case signUp
    
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
        let isLoggedIn: Bool
        do {
          _ = try KeychainManager.shared.load(forKey: KeychainManager.KeychainKey.accessToken)
          _ = try KeychainManager.shared.load(forKey: KeychainManager.KeychainKey.refreshToken)
          isLoggedIn = true
        } catch {
          isLoggedIn = false
        }
        
        self.destination = isLoggedIn
        ? Destination.home
        : Destination.login
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
  core.destination = .login
  return core.dependency.router.navigationController
}
#endif
