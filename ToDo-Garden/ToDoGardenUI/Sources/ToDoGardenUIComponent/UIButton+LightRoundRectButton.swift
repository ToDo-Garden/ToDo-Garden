//
//  UIButton+LightRoundRectButton.swift
//
//
//  Created by SONG on 5/17/24.
//

import UIKit

import ToDoGardenUIConstant

extension UIButton {
  public func applyLightRoundRectButtonStyle(title: String) {
    LightRoundRectButton.apply(to: self, title: title)
  }
}

private enum LightRoundRectButton {
  fileprivate static func apply(to button: UIButton, title: String) {
    var buttonConfiguration = UIButton.Configuration.filled()
    buttonConfiguration.contentInsets = Constant.LightRoundRectButton.contentsInsets
    buttonConfiguration.baseForegroundColor = UIColor.toDoGardenGreenDark
    buttonConfiguration.baseBackgroundColor = UIColor.toDoGardenGreenBackground
    
    let attributedString = NSAttributedString(
      string: title,
      attributes: [NSAttributedString.Key.font: UIFont.pretendardBodySemiBold]
    )

    button.configuration = buttonConfiguration
    button.setAttributedTitle(attributedString, for: UIControl.State.normal)
  }
}
