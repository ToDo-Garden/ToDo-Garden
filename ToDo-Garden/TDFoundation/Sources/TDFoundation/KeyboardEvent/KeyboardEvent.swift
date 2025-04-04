//
//  KeyboardEvent.swift
//  TDFoundation
//
//  Created by SONG on 4/4/25.
//

import UIKit

public enum KeyboardEvent: Sendable {
  case willShow(height: CGFloat, duration: TimeInterval)
  case willHide(duration: TimeInterval)
}

public enum UITextFieldNotificationObserver {
  public static func observeKeyboardEvents(
    for textField: UITextField,
    handler: @Sendable @escaping (KeyboardEvent) -> Void
  ) {
    let notificationCenter = NotificationCenter.default

    notificationCenter.addObserver(
      forName: UIResponder.keyboardWillShowNotification,
      object: nil,
      queue: .main
    ) { notification in
      guard let keys = notification.userInfo,
        let frame = keys[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
        let duration = keys[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else { return }
      handler(KeyboardEvent.willShow(height: frame.height, duration: duration))
    }

    notificationCenter.addObserver(
      forName: UIResponder.keyboardWillHideNotification,
      object: nil,
      queue: .main
    ) { notification in
      guard let keys = notification.userInfo,
        let duration = keys[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else { return }
      handler(KeyboardEvent.willHide(duration: duration))
    }
  }
}
