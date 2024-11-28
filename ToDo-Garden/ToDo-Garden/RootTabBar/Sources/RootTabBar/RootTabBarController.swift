//
//  RootTabBarController.swift
//  RootTabBar
//
//  Created by Noah on 11/26/24.
//

import UIKit

public final class RootTabBarController: UITabBarController {
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
  }
}

extension RootTabBarController {
  public enum RootTab {
    case home(index: Int, viewController: UIViewController)
    case share(index: Int, viewController: UIViewController)
    case settings(index: Int, viewController: UIViewController)
  }
  
  
  private func getSelectedTabBarImageView(in selectedTabBarButton: UIView) -> UIImageView? {
    let selectedImageView = selectedTabBarButton.subviews
      .compactMap { $0.subviews.first?.subviews.first as? UIImageView }
      .first
    
    return selectedImageView
  }
}
