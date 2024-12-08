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
      if flag { // 기존유저 로그인 끝난 뒤 목적지 == 홈
        self?.destination = .home
      } else {
        // 신규유저 로그인 끝난 뒤, 약관동의 "완료"버튼을 누르면 여기로 옵니다. 목적지 SignUpScene으로 전환 ( SignUpSceneBuilder() )
      }
    }
    : .home // 로그인 case 생기면, 로그인 플로우가 들어갈 예정 
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
