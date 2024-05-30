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
    buttonConfiguration.contentInsets = Constant.LightRoundRectButton.Layout.contentsInsetsPrimary
    let attributedString = NSAttributedString(
      string: title,
      attributes: [
        NSAttributedString.Key.font: UIFont.pretendardBodySemiBold
      ]
    )
    
    button.configurationUpdateHandler = { button in
      switch button.state {
      case UIControl.State.normal:
        button.configuration?.baseBackgroundColor = UIColor.toDoGardenGray1.withAlphaComponent(1.0)
        button.configuration?.baseForegroundColor = UIColor.toDoGardenGreenGray.withAlphaComponent(1.0)
      case UIControl.State.selected:
        button.configuration?.baseBackgroundColor = UIColor.toDoGardenGreenBackground
        button.configuration?.baseForegroundColor = UIColor.toDoGardenGreenDark
      default: break
      }
    }
    
    button.changesSelectionAsPrimaryAction = true
    button.configuration = buttonConfiguration
    button.setAttributedTitle(attributedString, for: UIControl.State.normal)
  }
}
