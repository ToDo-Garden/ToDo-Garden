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
  
  private func buildOnBoardingFlows(_ completion: (Bool) -> Void) -> [UIViewController] {
    let onboarding = IntroOnBoardingViewController()
    let tutroial = TutorialOnBoardingViewController()
    let login = LoginViewController()
    
    onboarding.addAction = { [weak navigationController] in
      navigationController?.pushViewController(tutroial, animated: true)
    }
    tutroial.endAction = { [weak navigationController] in
      navigationController?.pushViewController(login, animated: true)
    }
    // TODO: - Login Control Flow
    
    return [onboarding]
  }
}
