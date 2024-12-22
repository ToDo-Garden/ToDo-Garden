import UIKit

import HTTPClientAPI
import OnBoardingScene
import SignUpScene
import SignUpSceneAPI

@MainActor
public final class AppRouter {
  public var navigationController: UINavigationController = UINavigationController(
    rootViewController: UIViewController()
  )
  
  func switchTo(_ destination: AppCore.Destination, httpClient: HTTPClientAPI) {
    switch destination {
    case .home:
      self.navigationController.viewControllers = [
      ]
      
    case .onboarding(let completion):
      self.navigationController.viewControllers = self.buildOnBoardingFlows(completion, with: httpClient)
      
    case .signUp(let isEventAndPromotionalInformationAgreed, let completion):
      self.navigationController.pushViewController(
        self.buildSignUpSecne(
          completion,
          isEventAndPromotionalInformationAgreed,
          with: httpClient
        ),
        animated: false
      )
    case .none:
      break
    }
  }
  
  // completion 1번째 파라미터 == 기존유저인가? , 2번째 파라미터 == 광고성 알림 허용인가?
  private func buildOnBoardingFlows(
    _ completion: @escaping (Bool, Bool) -> Void,
    with httpClient: HTTPClientAPI
  ) -> [UIViewController] {
    let onboarding = IntroOnBoardingViewController()
    let tutroial = TutorialOnBoardingViewController()
    let login = LoginViewController(with: httpClient)
    
    onboarding.addAction = { [weak navigationController] in
      navigationController?.pushViewController(tutroial, animated: true)
    }
    tutroial.endAction = { [weak navigationController] in
      navigationController?.pushViewController(login, animated: true)
    }
    
    login.afterLoginAction = { isExistingUser in
      completion(isExistingUser, false)
    }
    
    login.doneButtonAction = { isEventAndPromotionalInformationAgreed in
      completion(false, isEventAndPromotionalInformationAgreed)
    }
    
    return [onboarding]
  }
  
  private func buildSignUpSecne(
    _ completion: @escaping () -> Void,
    _ isEventAndPromotionalInformationAgreed: Bool,
    with httpClient: HTTPClientAPI
  ) -> UIViewController {
    let worker = SignUpWorker(httpClient: httpClient)
    let builder = SignUpSceneBuilder(dependency: .init(signUpWorker: worker))
    let signUp: SignUpViewControllable = builder.build(
      with: SignUpScenePayload(
        agreeOptionalCondition: isEventAndPromotionalInformationAgreed
      )
    )
    signUp.modalPresentationStyle = .overFullScreen
    signUp.afterSignUpAction = completion
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
