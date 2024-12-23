import Foundation

import HTTPClient
import OnBoardingScene
import TDFoundation

@MainActor
public final class AppCore {
  public var dependency: Dependency
  public enum Destination {
    case onboarding((Bool, Bool) -> Void)
    case home // Binding HomeInteractor
    // case login
    case signUp(Bool, () -> Void)
    case none
  }
  var destination: Destination {
    didSet {
      self.dependency.router.switchTo(
        self.destination,
        httpClient: self.httpClient
      )
    }
  }
  private let httpClient = HTTPClient(
    transport: URLSessionTransport(urlSession: URLSession.shared),
    middlewares: [AuthenticationMiddleWare()]
  )
  
  public init(dependency: Dependency) {
    self.dependency = dependency
    self.destination = .none
  }
  
  // MARK: 앱시작시 무조건 먼저 호출해야하는 메소드
  public func getStarted() {
    self.destination = !dependency.userDefaults.hasShownFirstLaunchOnboarding
    ? .onboarding { [weak self] isMember, isEventAndPromotionalAgreed in
      if isMember {
        self?.destination = .home
      } else {
        self?.destination = .signUp(isEventAndPromotionalAgreed) { [weak self] in
          self?.destination = .home // 회원가입 완료하면 바로 홈으로
        }
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
