//
//  NavigationBarUIUpdator.swift
//
//
//  Created by Wood on 7/8/24.
//

import UIKit

import TDUtility

public final class NavigationBarUIUpdator {
  @ExecuteOnce private static var updateAction: (() -> Void)?

  public static func update(with window: UIWindow?) {
    self.updateAction = {
      self.updateNavigationBarApperance(with: window)
    }
  }
}

extension NavigationBarUIUpdator {
  private static func updateNavigationBarApperance(with window: UIWindow?) {
    let appearance = UINavigationBarAppearance()
    self.updateBackButtonAppearance(appearance)
    self.updateNavigationBarTitle(appearance)
    self.updateNavigationBarBottomLine(appearance, with: window)
    UINavigationBar.appearance().standardAppearance = appearance
    UINavigationBar.appearance().scrollEdgeAppearance = appearance
  }

  private static func updateBackButtonAppearance(_ appearance: UINavigationBarAppearance) {
    UINavigationBar.appearance().tintColor = UIColor.toDoGardenGreenDark
    appearance.backButtonAppearance.normal.titleTextAttributes = [
      NSAttributedString.Key.font: UIFont.systemFont(ofSize: 0)
    ]

    let imageInsets = UIEdgeInsets(
      top: 0,
      left: -15,
      bottom: 0,
      right: 0
    )
    let backIndicatorImage = UIImage.backwardButtonImage.withAlignmentRectInsets(imageInsets)
    appearance.setBackIndicatorImage(backIndicatorImage, transitionMaskImage: backIndicatorImage)
  }

  private static func updateNavigationBarTitle(_ appearance: UINavigationBarAppearance) {
    appearance.titleTextAttributes = [
      NSAttributedString.Key.foregroundColor: UIColor.toDoGardenGreenDark,
      NSAttributedString.Key.font: UIFont.pretendardHeadBold
    ]
  }

  private static func updateNavigationBarBottomLine(_ appearance: UINavigationBarAppearance, with window: UIWindow?) {
    appearance.backgroundColor = UIColor.toDoGardenWhite
    if let shadowImage = self.makeShadowImage(with: window) {
      appearance.shadowImage = shadowImage
    } else {
      appearance.shadowColor = UIColor.toDoGardenGreenGray
    }
  }

  private static func makeShadowImage(with window: UIWindow?) -> UIImage? {
    guard let screenWidth = window?.screen.bounds.width
    else { return nil }

    let shadowSize = CGSize(width: screenWidth, height: 1.0)
    let shadowImage = UIGraphicsImageRenderer(size: shadowSize).image { context in
      UIColor.toDoGardenGreenGray.setFill()
      let rect = CGRect(origin: CGPoint.zero, size: shadowSize)
      context.fill(rect)
    }

    return shadowImage
  }
}
