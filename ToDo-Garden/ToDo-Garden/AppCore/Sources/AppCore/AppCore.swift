import OnBoardingScene
import TDFoundation

import Foundation

@MainActor
public final class AppCore {
  public var dependency: Dependency
  public enum Destination {
    case onboarding((Bool) -> Void)
    case home // Binding HomeInteractor
    // case login
    case none
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
    self.destination = !dependency.userDefaults.hasShownFirstLaunchOnboarding
    ? .onboarding { [weak self] flag in
      if flag {
        self?.destination = .home
      } else {
        
      }
    }
    : .home
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
