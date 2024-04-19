//
//  UIButton+SearchGardenButton.swift
//
//
//  Created by Wood on 4/19/24.
//

import UIKit.UIButton

import ToDoGardenUIConstant
import ToDoGardenUIResource

extension UIButton {
  public func searchGardenButtonStyle() {
    SearchGardenButtonStyle.apply(to: self)
  }
}

private enum SearchGardenButtonStyle {
  fileprivate static func apply(to button: UIButton) {
    self.setupBackgroundColor(to: button)
    self.setupRoundedCorner(to: button)
  }
}

extension SearchGardenButtonStyle {
  private static func setupBackgroundColor(to button: UIButton) {
    button.backgroundColor = UIColor.toDoGardenGreenBackground
  }

  private static func setupRoundedCorner(to button: UIButton) {
    button.layer.cornerRadius = Constant.SearchGardenButton.Layout.cornerRadius
  }
}
