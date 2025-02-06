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
  
  public func unregisterBackgroundTransition() {
    NotificationCenter.default.removeObserver(self)
  }
}
