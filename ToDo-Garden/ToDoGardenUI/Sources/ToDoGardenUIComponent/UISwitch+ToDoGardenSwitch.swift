//
//  UISwitch+ToDoGardenSwitch.swift
//
//
//  Created by SONG on 3/1/24.
//

import UIKit.UISwitch
import ToDoGardenUIResource

extension UISwitch {
  public func ToDoGardenSwitchStyle() {
    self.setupOnTintColor()
  }
}

// MARK: - private functions

extension UISwitch {
  private func setupOnTintColor() {
    self.onTintColor = UIColor.toDoGardenGreenDark
  }
  
  private func setupOffTintColor() {
  }
}
