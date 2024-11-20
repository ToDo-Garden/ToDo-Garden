//
//  PageTransition.swift
//  TDFoundation
//
//  Created by Noah on 11/19/24.
//

import UIKit

public final class PageTransition: NSObject, UIViewControllerAnimatedTransitioning {
  private let transitionDuration: TimeInterval
  private let viewControllers: [UIViewController]
  
  public init(
    transitionDuration: TimeInterval = 0.5,
    viewControllers: [UIViewController]
  ) {
    self.transitionDuration = transitionDuration
    self.viewControllers = viewControllers
  }

extension PageTransition {
  private func getTransitionInfo(
    for key: UITransitionContextViewControllerKey,
    context: UIViewControllerContextTransitioning
  ) -> (UIViewController, UIView, Int)? {
    guard let viewController = context.viewController(forKey: key),
      let view = viewController.view,
      let index = self.getIndex(for: viewController)
    else { return nil }
    
    return (viewController, view, index)
  }
  
  private func getIndex(for targetViewController: UIViewController) -> Int? {
    for (index, viewController) in self.viewControllers.enumerated() where viewController == targetViewController {
      return index
    }
    return nil
  }
}
