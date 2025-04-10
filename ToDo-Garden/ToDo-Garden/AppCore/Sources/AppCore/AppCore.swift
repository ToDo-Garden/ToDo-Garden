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
    case login(Bool)
    case signUp
    
    case home(HomeSceneViewControllable)
  }
  var destination: Destination {
    didSet {
      self.dependency.router.switchTo(self.destination)
    }
  }
  private var upstream = AsyncStream<UpStreamOperation>.makeStream()
  private var upstreamTask: Task<Void, Never>?
  private var notificationTask: Task<Void, any Error>?
  
  public init(dependency: Dependency) {
    self.dependency = dependency
    self.destination = Destination.none
    self.prepare()
  }
  
  deinit {
    self.upstreamTask?.cancel()
    self.notificationTask?.cancel()
  }
  
  private func prepare() {
    self.dependency.router.upstreamContinuation = upstream.continuation
    self.upstreamTask = Task {
      for await opeartion in self.upstream.stream {
        // MARK: 여기에서 하위에서 전달하는 메세지를 해석하면 됩니다.
      }
    }
  }
  
  // MARK: 앱시작시 무조건 먼저 호출해야하는 메소드
  public func getStarted() {
    self.dependency.router.navigationController.navigationBar.isHidden = true
    if !self.dependency.userDefaults.hasShownFirstLaunchOnboarding {
      self.destination = Destination.onboarding
      Task {
        await self.dependency.userDefaults.setHasShownFirstLaunchOnboarding(true)
      }
    } else {
      self.destination = self.dependency.isLoggedIn()
      ? Destination.home(
        self.dependency.router.sceneBuilder.home.build(
          with: HomeScenePayload(
            delegate: {
              self.remainToDoCount($0)
            }
          )
        )
      )
      : Destination.login(true)
    }
  }
  
  public func didBecomeActive() {
    self.notificationTask?.cancel()
    self.notificationTask = Task {
      let manager = self.dependency.notificationManager
      let isAuthorized = try await manager.fetchPermission()
      if isAuthorized {
        for await _ in self.dependency.scheduledAlertClient.stream() {
          NotificationCenter.default.post(
            name: .init("did become active"),
            object: nil
          )
        }
      }
    }
  }
}

extension AppCore {
  public func remainToDoCount(_ count: Int) {
    self.dependency.notificationManager.pushDailyToDoReminder(count: count)
  }
}

struct HomeScenePayload: HomeScenePayloadable {
  var delegate: ((Int) -> Void)?
}

extension AppCore {
  public enum UpStreamOperation: Sendable {
    case reminder(count: Int)
  }
}

#if DEBUG
import UIKit
@available(iOS 17.0, *)
#Preview {
  let core = AppCore(dependency: .live)
  core.destination = .login(false)
  return core.dependency.router.navigationController
}
#endif
