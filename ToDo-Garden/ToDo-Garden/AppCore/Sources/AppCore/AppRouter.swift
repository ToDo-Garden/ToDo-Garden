import UIKit

import HTTPClientAPI
import OnBoardingScene

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
      
    case .none:
      break
    }
  }
  
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

    login.afterLoginAction = { completion(false, false) }
    // TODO: 1번째 파라미터 == 기존유저인가? , 2번째 파라미터 == 광고성 알림 허용인가?
    
    login.doneButtonAction = { isEventAndPromotionalInformationAgreed in
      completion(false, isEventAndPromotionalInformationAgreed)
    }
    
    return [onboarding]
  }
}
