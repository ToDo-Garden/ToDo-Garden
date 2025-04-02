import Foundation

import HomeSceneAPI
import TDFoundation
import UserInfoScene

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
  
  private var notificationTask: Task<Void, any Error>?
  
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
  }
  
  public func didBecomeActive() {
    self.notificationTask?.cancel()
    self.notificationTask = Task {
      let manager = self.dependency.notificationManager
      let isAuthorized = try await manager.fetchPermission()
      if isAuthorized {
        for await _ in self.dependency.scheduledAlertClient.stream() {
          manager.pushDailyToDoReminder(count: 5)
        }
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
