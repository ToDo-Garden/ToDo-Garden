//
//  ToDoGardenBoxButton.swift
//
//
//  Created by SONG on 3/22/24.
//

import UIKit.UIButton

public final class ToDoGardenBoxButton: UIButton {
  init() {
    super.init(frame: CGRect.zero)
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
  }
}
