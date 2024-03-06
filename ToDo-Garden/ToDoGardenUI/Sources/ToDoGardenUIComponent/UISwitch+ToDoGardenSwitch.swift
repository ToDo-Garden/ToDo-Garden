//
//  UISwitch+ToDoGardenSwitch.swift
//
//
//  Created by SONG on 3/1/24.
//

import UIKit.UISwitch

import ToDoGardenUIResource

public final class ToDoGardenSwitch: UISwitch {
  public init() {
    super.init(frame: .zero)
    self.setupOnTintColor()
  }
  
  public convenience init(isOn: Bool) {
    self.init()
    self.isOn = isOn
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    self.setupOnTintColor()
  }
  
  public override func layoutSubviews() {
    super.layoutSubviews()
    self.setupOffTintColor()
  }
}

// MARK: - private functions

extension ToDoGardenSwitch {
  private func setupOnTintColor() {
    self.onTintColor = UIColor.toDoGardenGreenDark
  }
  
  private func setupOffTintColor() {
    let offBackgroundView = self.subviews.first?.subviews.first
    offBackgroundView?.backgroundColor = UIColor.toDoGardenGreenGray
  }
}
