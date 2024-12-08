import OnBoardingScene

import UIKit

@MainActor
public final class AppRouter {
  public var navigationController: UINavigationController = UINavigationController(
    rootViewController: UIViewController()
  )
  
  func switchTo(_ destination: AppCore.Destination) {
    switch destination {
    case .home:
      self.navigationController.viewControllers = [
      ]
      
    case .onboarding(let completion):
      self.navigationController.viewControllers = self.buildOnBoardingFlows(completion)
      
    case .none:
      break
    }
  }
  
  private func buildOnBoardingFlows(_ completion: @escaping (Bool) -> Void) -> [UIViewController] {
    let onboarding = IntroOnBoardingViewController()
    let tutroial = TutorialOnBoardingViewController()
    let login = LoginViewController()
    
    onboarding.addAction = { [weak navigationController] in
      navigationController?.pushViewController(tutroial, animated: true)
    }
    tutroial.endAction = { [weak navigationController] in
      navigationController?.pushViewController(login, animated: true)
    }

    login.afterLoginAction = { [weak login] isExistingUser in
      if isExistingUser {
        completion(true)
      } else {
        login?.showTermAgreementViewForRoutingToSignUpScene()
      }
    }
    
    login.doneButtonAction = { isEventAndPromotionalInformationAgreed in
      _ = isEventAndPromotionalInformationAgreed
      // TODO: 광고성 알림 수신 여부(isEventAndPromotionalInformationAgreed)를 SignUpScene의 payload로 받게 되어있음.
      completion(false)
    }
    
    return [onboarding]
  }
}
