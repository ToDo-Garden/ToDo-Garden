//
//  ToDoGardenBoxButton.swift
//
//
//  Created by SONG on 3/20/24.
//

import UIKit.UIButton

import ToDoGardenUIConstant

public class ToDoGardenBoxButton: UIButton {
  public override var isEnabled: Bool {
    didSet{
      self.updateBackgroundColor()
    }
  }
  
  init() {
    super.init(frame: CGRect.zero)
    self.enable()
  }
  
  public convenience init(
    isRoundRect: Bool,
    text: String,
    sizeType: ToDoGardenBoxButtonConstant.Size
  ) {
    self.init()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    self.enable()
  }
  
  public func enable() {
    self.isEnabled = true
  }
  
  public func disable() {
    self.isEnabled = false
  }
}

//private method

extension ToDoGardenBoxButton {
  private func updateBackgroundColor() {
    if self.isEnabled {
      self.backgroundColor = UIColor.toDoGardenGreenDark
    }
    else {
      self.backgroundColor = UIColor.toDoGardenGreenGray
    }
  }
}
