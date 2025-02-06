//
//  TransitionHandlable.swift
//  TDUtility
//
//  Created by SONG on 2/6/25.
//

import UIKit

@objc public protocol TransitionHandlable: AnyObject {
  @objc func handleBackgroundTransition()
}

extension TransitionHandlable {
  public func registerBackgroundTransitionObserver() {
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(self.handleBackgroundTransition),
      name: UIScene.didEnterBackgroundNotification,
      object: nil
    )
  }
  
  // swiftlint:disable notification_center_detachment
  public func unregisterBackgroundTransition() {
    NotificationCenter.default.removeObserver(self)
  }
  // swiftlint:enable notification_center_detachment
}
