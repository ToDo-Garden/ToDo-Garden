import OnBoardingScene

import UIKit

@MainActor
public final class AppRouter {
  public var navigationController: UINavigationController = UINavigationController(
    rootViewController: UIViewController()
  )

  public enum Destination {
    case onboarding
    case home
  }
  func switchTo(_ destination: Destination) {
    switch destination {
    case Destination.home:
      self.navigationController.viewControllers = [
      ]
      
    case Destination.onboarding:
      self.navigationController.viewControllers = self.buildOnBoardingFlows { [weak self] flag in
        if flag {
          self?.switchTo(.home)
        } else {
          // -> Route to SignUp
        }
      }
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
