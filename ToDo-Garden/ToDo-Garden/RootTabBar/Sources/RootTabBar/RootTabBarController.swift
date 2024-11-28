//
//  RootTabBarController.swift
//  RootTabBar
//
//  Created by Noah on 11/26/24.
//

import UIKit

import TDFoundation
import ToDoGardenUIAPI
import ToDoGardenUIResource

public final class RootTabBarController: UITabBarController, HapticFeedbackable {
  typealias StringLiteral = Constant.StringLiteral.RootTabBarController
  private let rootTabBar = RootTabBar()
  private let bounceAnimation: CAKeyframeAnimation = {
    let bounceAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
    bounceAnimation.values = [1.0, 1.4, 0.9, 1.02, 1.0]
    bounceAnimation.duration = TimeInterval(0.3)
    bounceAnimation.calculationMode = CAAnimationCalculationMode.cubic
    
    return bounceAnimation
  }()
  private let tabItems: [RootTab]
  
  public init(tabItems: [RootTab]) {
    self.tabItems = tabItems
    super.init(nibName: nil, bundle: nil)
    self.setup()
    self.delegate = self
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  public override func loadView() {
    super.loadView()
    self.setValue(self.rootTabBar, forKey: "tabBar")
  }
  
  public override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
    if let index = tabBar.items?.firstIndex(of: item),
      index + 1 <= tabBar.subviews.count {
      let tabBarButtton = tabBar.subviews[index + 1]
      let selectedImageView = self.getSelectedTabBarImageView(in: tabBarButtton)
      selectedImageView?.layer.add(self.bounceAnimation, forKey: nil)
    }
    self.triggerHapticFeedback(type: HapticFeedbackType.selection)
  }
}

extension RootTabBarController: UITabBarControllerDelegate {
  public func tabBarController(
    _ tabBarController: UITabBarController,
    animationControllerForTransitionFrom fromVC: UIViewController,
    to toVC: UIViewController
  ) -> (any UIViewControllerAnimatedTransitioning)? {
    guard let viewControllers = tabBarController.viewControllers
    else { return nil }
    
    return PageTransition(viewControllers: viewControllers)
  }
}

extension RootTabBarController {
  public enum RootTab {
    case home(index: Int, viewController: UIViewController)
    case share(index: Int, viewController: UIViewController)
    case settings(index: Int, viewController: UIViewController)
  }
  
  private func homeTabBarItemStyle(for tabBarItem: UITabBarItem) {
    tabBarItem.image = UIImage.homeTabBarItemImage
    tabBarItem.title = StringLiteral.homeTabTitle
  }
  
  private func shareTabBarItemStyle(for tabBarItem: UITabBarItem) {
    tabBarItem.image = UIImage.shareTabBarItemImage
    tabBarItem.title = StringLiteral.shareTabTitle
  }
  
  private func settingsTabBarItemStyle(for tabBarItem: UITabBarItem) {
    tabBarItem.image = UIImage.settingsTabBarItemImage
    tabBarItem.title = StringLiteral.settingsTabTitle
  }
  
  private func getSelectedTabBarImageView(in selectedTabBarButton: UIView) -> UIImageView? {
    let selectedImageView = selectedTabBarButton.subviews
      .compactMap { $0.subviews.first?.subviews.first as? UIImageView }
      .first
    
    return selectedImageView
  }
  
  private func setup() {
    self.setupViewControllers()
    self.setupAppearance()
  }
  
  private func setupViewControllers() {
    var viewControllers = [UIViewController]()
    for tabItem in self.tabItems {
      switch tabItem {
      case RootTab
        .home(_, let viewController),
        RootTab
          .share(_, let viewController),
        RootTab
          .settings(_, let viewController):
        viewControllers.append(viewController)
      }
    }
    self.viewControllers = viewControllers
  }
  
  private func setupAppearance() {
    self.view.backgroundColor = UIColor.white
    self.setupTabBarStyles()
  }
  
  private func setupTabBarStyles() {
    for tabItem in tabItems {
      switch tabItem {
      case RootTab.home(let index, _):
        self.tabBarItem(atIndex: index)
          .map { self.homeTabBarItemStyle(for: $0) }
      case RootTab.share(let index, _):
        self.tabBarItem(atIndex: index)
          .map { self.shareTabBarItemStyle(for: $0) }
      case RootTab.settings(let index, _):
        self.tabBarItem(atIndex: index)
          .map { self.settingsTabBarItemStyle(for: $0) }
      }
    }
  }
  
  private func tabBarItem(atIndex index: Int) -> UITabBarItem? {
    if index < (self.tabBar.items?.count ?? 0) {
      if let item = self.tabBar.items?[index] {
        return item
      }
    }
    
    return nil
  }
}
