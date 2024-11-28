//
//  RootTabBarController.swift
//  RootTabBar
//
//  Created by Noah on 11/26/24.
//

import UIKit

public final class RootTabBarController: UITabBarController {
  private let tabItems: [RootTab]
  
  public init(tabItems: [RootTab]) {
    self.tabItems = tabItems
    super.init(nibName: nil, bundle: nil)
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension RootTabBarController {
  public enum RootTab {
    case home(index: Int, viewController: UIViewController)
    case share(index: Int, viewController: UIViewController)
    case settings(index: Int, viewController: UIViewController)
  }
  
}
