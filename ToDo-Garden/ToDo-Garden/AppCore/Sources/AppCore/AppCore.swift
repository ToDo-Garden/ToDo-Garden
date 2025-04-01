import Foundation

import HomeSceneAPI
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
    
    case home(HomeSceneViewControllable)
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
    dependency.router.navigationController.navigationBar.isHidden = true
    if !self.dependency.userDefaults.hasShownFirstLaunchOnboarding {
      self.destination = Destination.onboarding
      Task {
        await self.dependency.userDefaults.setHasShownFirstLaunchOnboarding(true)
      }
    } else {
      if self.dependency.isLoggedIn() {
        switchToHome()
      } else {
        self.destination = .login
      }
    }
  }
  
  private func switchToHome() {
    let builder = self.dependency.router.sceneBuilder.home
    self.destination = Destination.home(builder.build())
    
    // 앱의 생명주기를 같이하는 작업이기 때문에 관리할 필요없습니다.
    Task {
      for await _ in self.dependency.scheduledAlertClient.stream() {
      }
    }
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
