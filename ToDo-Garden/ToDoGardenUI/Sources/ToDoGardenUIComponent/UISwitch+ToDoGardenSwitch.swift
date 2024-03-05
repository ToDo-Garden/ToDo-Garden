//
//  UISwitch+ToDoGardenSwitch.swift
//
//
//  Created by SONG on 3/1/24.
//

import ToDoGardenUIResource
import UIKit.UISwitch

extension UISwitch {
  public func toDoGardenSwitchStyle(isOn: Bool) {
    self.isOn = isOn
    self.setupOnTintColor()
    self.setupOffTintColor()
  }
}

// MARK: - private functions

extension UISwitch {
  private func setupOnTintColor() {
    self.onTintColor = UIColor.toDoGardenGreenDark
  }
  
  private func setupOffTintColor() {
    self.subviews.first?.subviews.first?.backgroundColor = UIColor.toDoGardenGreenGray
  }
}
