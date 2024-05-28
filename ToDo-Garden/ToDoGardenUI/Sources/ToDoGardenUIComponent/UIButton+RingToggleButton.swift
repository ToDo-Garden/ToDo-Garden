//
//  UIButton+RingToggleButton.swift
//
//
//  Created by SONG on 5/17/24.
//

import UIKit

import ToDoGardenUIResource

extension UIButton {
  public func applyRingToggleButtonStyle() {
    RingToggleButton.apply(to: self)
  }
}

private enum RingToggleButton {
  fileprivate static func apply(to button: UIButton) {
    button.setBackgroundImage(UIImage.ringToggleOff, for: UIControl.State.normal)
    button.setBackgroundImage(UIImage.ringToggleOn, for: UIControl.State.selected)
    button.setBackgroundImage(UIImage.ringToggleHighlighted, for: UIControl.State.highlighted)
    button.setBackgroundImage(
      UIImage.ringToggleHighlighted,
      for: [
        UIControl.State.selected,
        UIControl.State.highlighted
      ]
    )
    button.changesSelectionAsPrimaryAction = true
  }
}
