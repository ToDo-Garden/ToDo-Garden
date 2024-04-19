//
//  UIButton+SearchGardenButton.swift
//
//
//  Created by Wood on 4/19/24.
//

import UIKit.UIButton

import ToDoGardenUIResource

extension UIButton {
  public func searchGardenButtonStyle() {
    SearchGardenButtonStyle.apply(to: self)
  }
}

private enum SearchGardenButtonStyle {
  fileprivate static func apply(to button: UIButton) {
    SearchGardenButtonStyle.setupBackgroundColor(to: button)
  }
}

extension SearchGardenButtonStyle {
  private static func setupBackgroundColor(to button: UIButton) {
    button.backgroundColor = UIColor.toDoGardenGreenBackground
  }
}
