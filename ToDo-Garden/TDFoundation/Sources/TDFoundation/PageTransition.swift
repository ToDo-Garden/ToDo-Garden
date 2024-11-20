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
}
