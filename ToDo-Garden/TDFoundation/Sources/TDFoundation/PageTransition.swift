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
  
  public func transitionDuration(using transitionContext: (any UIViewControllerContextTransitioning)?) -> TimeInterval {
    return self.transitionDuration
  }
  
  // swiftlint:disable function_body_length large_tuple
  public func animateTransition(using transitionContext: any UIViewControllerContextTransitioning) {
    guard
      let (fromViewController, fromView, fromIndex) = self.getTransitionInfo(
        for: UITransitionContextViewControllerKey.from,
        context: transitionContext
      ),
      let (_, toView, toIndex) = self.getTransitionInfo(
        for: UITransitionContextViewControllerKey.to,
        context: transitionContext
      )
    else {
      transitionContext.completeTransition(false)
      return
    }
    
    let frame = transitionContext.initialFrame(for: fromViewController)
    var toFrameStart = frame
    let offsetX = frame.width * 0.1
    toFrameStart.origin.x = toIndex > fromIndex
      ? frame.origin.x + offsetX
      : frame.origin.x - offsetX
    toView.frame = toFrameStart
    transitionContext.containerView.addSubview(toView)
    transitionContext.containerView.addSubview(fromView)
    
    UIView.animate(
      withDuration: self.transitionDuration,
      delay: 0,
      usingSpringWithDamping: 0.8,
      initialSpringVelocity: 0.7,
      options: [UIView.AnimationOptions.curveEaseInOut],
      animations: {
        fromView.layer.opacity = 0
        toView.frame = frame
        toView.layer.opacity = 1
      },
      completion: { success in
        fromView.removeFromSuperview()
        transitionContext.completeTransition(success)
      }
    )
  }
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
  // swiftlint:enable function_body_length large_tuple
  
  private func getIndex(for targetViewController: UIViewController) -> Int? {
    for (index, viewController) in self.viewControllers.enumerated() where viewController == targetViewController {
      return index
    }
    return nil
  }
}
