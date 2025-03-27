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
@MainActor
public final class AppRouter {
  private let httpClient: HTTPClientAPI
  let sceneBuilder: SceneBuilder
  
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
      self.navigationController.viewControllers = [
        RootTabBarController(tabItems: [
          RootTabBarController.RootTab.home(index: 0, viewController: viewController),
          RootTabBarController.RootTab.share(index: 1, viewController: UINavigationController(rootViewController: sceneBuilder.shareGarden.build())),
          RootTabBarController.RootTab.settings(index: 2, viewController: sceneBuilder.setting.build())
        ])
      ]
      
    case Destination.onboarding:
      self.navigationController.viewControllers = [
        self.buildIntroOnBoardingViewController()
      ]
      
    case Destination.tutorial:
      self.navigationController.pushViewController(
        self.buildTutorialViewController(),
        animated: true
      )
      
    case Destination.login:
      self.navigationController.pushViewController(
        self.buildLoginViewController(),
        animated: true
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
      self?.switchTo(Destination.login)
    }
    return tutroial
  }
  
  private func buildLoginViewController() -> UIViewController {
    let login = LoginViewController(with: self.httpClient)
    login.afterLoginAction = { [weak self] isExistingUser in
      self?.switchTo(
        isExistingUser
        ? Destination.home(HomeSceneBuilder(dependency: .live).build())
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
    let signUp: SignUpViewControllable = sceneBuilder.signup.build(
      with: SignUpScenePayload(
        agreeOptionalCondition: isEventAndPromotionalInformationAgreed
      )
    )
    signUp.modalPresentationStyle = .overFullScreen
    signUp.afterSignUpAction = { [weak self] in
      self?.switchTo(Destination.home(HomeSceneBuilder(dependency: .live).build()))
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
    let setting: SettingSceneBuilder
  }
}
// swiftlint:enable function_body_length
