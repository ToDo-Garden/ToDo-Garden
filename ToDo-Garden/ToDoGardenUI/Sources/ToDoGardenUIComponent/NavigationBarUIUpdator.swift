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
