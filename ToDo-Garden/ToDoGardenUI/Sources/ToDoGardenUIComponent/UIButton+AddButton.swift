//
//  UIButton+addButton.swift
//
//
//  Created by Wood on 3/4/24.
//

import ToDoGardenUIResource
import UIKit.UIButton

extension UIButton {
  public func addButtonStyle(with title: String) {
    self.setupUIAppearance(with: title)
  }
}

extension UIButton {
  private func setupUIAppearance(with title: String) {
    AddButtonStyle.apply(for: self, with: title)
  }
}

private enum AddButtonStyle {
  fileprivate static func apply(for button: UIButton, with title: String) {
    
  }
}
