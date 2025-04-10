import UIKit

import HomeScene
import HomeSceneAPI
import HTTPClientAPI
import OnBoardingScene
import RootTabBar
import SettingScene
import ShareGardenScene
import SignUpScene
import SignUpSceneAPI

// swiftlint:disable function_body_length
/// TODO: 여러가지 이유로 Shared로 만들면 훨씬 좋을 거 같습니다.
@MainActor
public final class AppRouter {
  private let httpClient: HTTPClientAPI
  var sceneBuilder: SceneBuilder
  var upstreamContinuation: AsyncStream<AppCore.UpStreamOperation>.Continuation?
  
  public init(
    httpClient: HTTPClientAPI,
    sceneBuilder: SceneBuilder
  ) {
    self.httpClient = httpClient
    self.sceneBuilder = sceneBuilder
  }
  
  public var navigationController: UINavigationController = UINavigationController(
    rootViewController: UIViewController()
  )
  
  typealias Destination = AppCore.Destination
  func switchTo(_ destination: Destination) {
    switch destination {
    case Destination.home(let viewController):
      let tabBarController = RootTabBarController(
        tabItems: [
          RootTabBarController.RootTab.home(index: 0, viewController: viewController),
          RootTabBarController.RootTab.share(
            index: 1,
            viewController: UINavigationController(
              rootViewController: self.sceneBuilder.shareGarden.build()
            )
          ),
          RootTabBarController.RootTab.settings(index: 2, viewController: self.sceneBuilder.setting.build())
        ]
      )
      self.navigationController.setRootViewController(tabBarController)
      
    case Destination.onboarding:
      self.navigationController.viewControllers = [
        self.buildIntroOnBoardingViewController()
      ]
      
    case Destination.tutorial:
      self.navigationController.pushViewController(
        self.buildTutorialViewController(),
        animated: true
      )
      
    case Destination.login(let isForward):
      self.navigationController
        .setRootViewController(
          self.buildLoginViewController(),
          withForwardTransition: isForward
        )
      
    case Destination.signUp:
      self.navigationController.pushViewController(
        self.buildSignUpSecne(),
        animated: false
      )
      
    case Destination.none:
      break
    }
  }
  
  private func buildIntroOnBoardingViewController() -> UIViewController {
    let onboarding = IntroOnBoardingViewController()
    onboarding.addAction = { [weak self] in
      self?.switchTo(Destination.tutorial)
    }
    return onboarding
  }
  
  private func buildTutorialViewController() -> UIViewController {
    let tutroial = TutorialOnBoardingViewController()
    tutroial.endAction = { [weak self] in
      self?.switchTo(Destination.login(true))
    }
    return tutroial
  }
  
  private func buildLoginViewController() -> UIViewController {
    let login = LoginViewController(with: self.httpClient)
    login.afterLoginAction = { [weak self] isExistingUser in
      guard let self else { return }
      let homeScenePayload = HomeScenePayload(
        delegate: { [weak self] in
          self?.upstreamContinuation?.yield(.reminder(count: $0))
        }
      )
      self.switchTo(
        isExistingUser
        ? Destination.home(self.sceneBuilder.home.build(with: homeScenePayload))
        : Destination.signUp
      )
    }
    login.doneButtonAction = { [weak self] _ /*마케팅 정보 인자*/ in
      self?.switchTo(Destination.signUp)
    }
    return login
  }
  
  private func buildSignUpSecne() -> UIViewController {
    // TODO: - 추후 마켓팅 정보를 대비한 값입니다.
    let isEventAndPromotionalInformationAgreed = true
    let signUp: SignUpViewControllable = self.sceneBuilder.signup.build(
      with: SignUpScenePayload(
        agreeOptionalCondition: isEventAndPromotionalInformationAgreed
      )
    )
    signUp.modalPresentationStyle = .overFullScreen
    signUp.afterSignUpAction = { [weak self] in
      guard let self else { return }
      
      let homeScenePayload = HomeScenePayload(
        delegate: { [weak self] in
          self?.upstreamContinuation?.yield(.reminder(count: $0))
        }
      )
      self.switchTo(Destination.home(self.sceneBuilder.home.build(with: homeScenePayload)))
    }
    return signUp
  }
}

extension AppRouter {
  struct SignUpScenePayload: SignUpScenePayloadable {
    let agreeOptionalCondition: Bool
    
    init(agreeOptionalCondition: Bool) {
      self.agreeOptionalCondition = agreeOptionalCondition
    }
  }
  
  public struct SceneBuilder {
    let home: HomeSceneBuilder
    let signup: SignUpSceneBuilder
    let shareGarden: ShareGardenSceneBuilder
    var setting: SettingSceneBuilder!
  }
}
// swiftlint:enable function_body_length
