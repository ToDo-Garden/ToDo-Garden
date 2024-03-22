//
//  ToDoGardenBoxButton.swift
//
//
//  Created by SONG on 3/22/24.
//

import UIKit.UIButton

public final class ToDoGardenBoxButton: UIButton {
  public override var isEnabled: Bool {
    didSet {
      self.updateBackgroundColor()
    }
  }
  
  init() {
    super.init(frame: CGRect.zero)
    enable()
  }
  
  public convenience init(
    isRoundRect: Bool,
    text: String,
    sizeType: CGSize
  ) {
    self.init()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    enable()
  }
  
  public func enable() {
    self.isEnabled = true
  }
  
  public func disable() {
    self.isEnabled = false
  }
}

// private method

extension ToDoGardenBoxButton {
  private func updateBackgroundColor() {
    if self.isEnabled {
      self.backgroundColor = UIColor.toDoGardenGreenDark
    } else {
      self.backgroundColor = UIColor.toDoGardenGreenGray
    }
  }
}
