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
    self.updateAction?()
  }
}

extension NavigationBarUIUpdator {
  private static func updateNavigationBarApperance(with window: UIWindow?) {
    let appearance = UINavigationBarAppearance()
    self.updateBackButtonAppearance(appearance)
    self.updateNavigationBarTitle(appearance)
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
}
