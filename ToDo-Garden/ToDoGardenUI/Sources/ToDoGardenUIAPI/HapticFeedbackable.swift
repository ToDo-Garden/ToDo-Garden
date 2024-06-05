//
//  HapticFeedbackable.swift
//
//
//  Created by Noah on 6/5/24.
//

import class UIKit.UIImpactFeedbackGenerator

public protocol HapticFeedbackable {
  func triggerHapticFeedback(style: UIImpactFeedbackGenerator.FeedbackStyle)
}

extension HapticFeedbackable {
  public func triggerHapticFeedback(
    style: UIImpactFeedbackGenerator.FeedbackStyle = UIImpactFeedbackGenerator.FeedbackStyle.medium
  ) {
    let generator = UIImpactFeedbackGenerator(style: style)
    generator.impactOccurred()
  }
}
