import UIKit

extension UINavigationController {
  public func setRootViewController(
    _ newViewController: UIViewController,
    withForwardTransition: Bool = true
  ) {
    if withForwardTransition {
      self.setViewControllers([newViewController], animated: true)
    } else {
      guard let last = viewControllers.last else {
        #if DEBUG
        debugPrint("⚠️ Cannot perform pop-style transition: navigation stack is empty.")
        #endif
        return
      }
      self.setViewControllers([newViewController, last], animated: false)
      self.popViewController(animated: true)
    }
  }
}
