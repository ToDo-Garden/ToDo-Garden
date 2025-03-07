import UIKit

import HTTPClientAPI
import OnBoardingScene
import SignUpScene
import SignUpSceneAPI

// swiftlint:disable function_body_length
@MainActor
public final class AppRouter {
  private let httpClient: HTTPClientAPI
  
  public init(httpClient: HTTPClientAPI) {
    self.httpClient = httpClient
  }
  
  public var navigationController: UINavigationController = UINavigationController(
    rootViewController: UIViewController()
  )
  
  typealias Destination = AppCore.Destination
  func switchTo(_ destination: Destination) {
    switch destination {
    case Destination.home:
      self.navigationController.viewControllers = []
      
    case Destination.onboarding:
      let onboarding = IntroOnBoardingViewController()
      onboarding.addAction = { [weak self] in
        self?.switchTo(Destination.tutorial)
      }
      self.navigationController.viewControllers = [onboarding]
      
    case Destination.tutorial:
      let tutroial = TutorialOnBoardingViewController()
      tutroial.endAction = { [weak self] in
        self?.switchTo(
          Destination.login { $0 ? Destination.home : Destination.signUp($1) }
        )
      }
      self.navigationController.pushViewController(tutroial, animated: true)
      
    case Destination.login(let destination):
      let login = LoginViewController(with: httpClient)
      login.afterLoginAction = { [weak self] isExistingUser in
        self?.switchTo(destination(isExistingUser, false))
      }
      login.doneButtonAction = { [weak self] isEventAndPromotionalInformationAgreed in
        self?.switchTo(destination(false, isEventAndPromotionalInformationAgreed))
      }
      self.navigationController.pushViewController(login, animated: true)
      
    case Destination.signUp(let isEventAndPromotionalInformationAgreed):
      self.navigationController.pushViewController(
        self.buildSignUpSecne(isEventAndPromotionalInformationAgreed),
        animated: false
      )
      
    case Destination.none:
      break
    }
  }
  
  private func buildSignUpSecne(
    _ isEventAndPromotionalInformationAgreed: Bool
  ) -> UIViewController {
    let worker = SignUpWorker(httpClient: httpClient)
    let builder = SignUpSceneBuilder(dependency: .init(signUpWorker: worker))
    let signUp: SignUpViewControllable = builder.build(
      with: SignUpScenePayload(
        agreeOptionalCondition: isEventAndPromotionalInformationAgreed
      )
    )
    signUp.modalPresentationStyle = .overFullScreen
    signUp.afterSignUpAction = { [weak self] in
      self?.switchTo(Destination.home)
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
}
// swiftlint:enable function_body_length
