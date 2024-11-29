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
    transitionDuration: TimeInterval = 0.35,
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
    var fromFrameEnd = frame
    
    let toFrameOffsetX = frame.width * 0.1
    let fromFrameOffsetX = frame.width * 0.1
    toFrameStart.origin.x = toIndex > fromIndex
      ? frame.origin.x + toFrameOffsetX
      : frame.origin.x - toFrameOffsetX
    toView.frame = toFrameStart
    fromFrameEnd.origin.x = toIndex > fromIndex
      ? frame.origin.x - fromFrameOffsetX
      : frame.origin.x + fromFrameOffsetX
    
    transitionContext.containerView.addSubview(fromView)
    transitionContext.containerView.addSubview(toView)
    
    UIView.animate(
      withDuration: self.transitionDuration,
      delay: 0,
      usingSpringWithDamping: 0.8,
      initialSpringVelocity: 0.7,
      options: [UIView.AnimationOptions.curveEaseInOut],
      animations: {
        fromView.frame = fromFrameEnd
        toView.frame = frame
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
