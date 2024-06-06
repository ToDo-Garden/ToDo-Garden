//
//  HapticFeedbackable.swift
//
//
//  Created by Noah on 6/5/24.
//

import class UIKit.UIImpactFeedbackGenerator
import class UIKit.UINotificationFeedbackGenerator
import class UIKit.UISelectionFeedbackGenerator

public enum HapticFeedbackType {
  case impact(style: UIImpactFeedbackGenerator.FeedbackStyle)
  case selection
  case notification(type: UINotificationFeedbackGenerator.FeedbackType)
}

public protocol HapticFeedbackable {
  func triggerHapticFeedback(type: HapticFeedbackType)
}

extension HapticFeedbackable {
  public func triggerHapticFeedback(
    type: HapticFeedbackType = HapticFeedbackType.impact(
      style: UIImpactFeedbackGenerator.FeedbackStyle.medium
    )
  ) {
    switch type {
    case HapticFeedbackType.impact(let style):
      let generator = UIImpactFeedbackGenerator(style: style)
      generator.impactOccurred()
    case HapticFeedbackType.selection:
      let generator = UISelectionFeedbackGenerator()
      generator.selectionChanged()
    case HapticFeedbackType.notification(let feedbackType):
      let generator = UINotificationFeedbackGenerator()
      generator.notificationOccurred(feedbackType)
    }
  }
}
