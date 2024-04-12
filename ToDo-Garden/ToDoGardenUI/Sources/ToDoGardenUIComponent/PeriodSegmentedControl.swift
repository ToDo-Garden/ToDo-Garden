//
//  PeriodSegmentedControl.swift
//
//
//  Created by SONG on 4/12/24.
//

import UIKit.UIControl

import ToDoGardenUIConstant
import ToDoGardenUIResource

public final class PeriodSegmentedControl: UIControl {
  
  public init(items: [String] = Constant.PeriodSegmentedControl.Content.defaultItems) {
    super.init(frame: CGRect.zero)
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }
}

//MARK: - private functions
extension PeriodSegmentedControl {
  
}
