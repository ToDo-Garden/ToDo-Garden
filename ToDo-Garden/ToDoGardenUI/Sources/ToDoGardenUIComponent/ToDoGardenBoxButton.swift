//
//  ToDoGardenBoxButton.swift
//
//
//  Created by SONG on 3/20/24.
//

import UIKit.UIButton

import ToDoGardenUIConstant

public class ToDoGardenBoxButton: UIButton {
  init() {
    super.init(frame: CGRect.zero)
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
  }
  
}
