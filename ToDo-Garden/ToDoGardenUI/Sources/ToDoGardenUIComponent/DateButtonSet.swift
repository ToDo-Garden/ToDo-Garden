//
//  DateButtonSet.swift
//
//
//  Created by SONG on 5/28/24.
//

import UIKit

import ToDoGardenUIConstant

public class DateButtonSet: UIStackView {
  public var delegate: DateButtonSetDelegate?
  private let startDateButton: UIButton
  private let startLabelButton: UIButton
  private let endDateButton: UIButton
  private let endLabelButton: UIButton
  
  init() {
    self.delegate = nil
    self.startDateButton = UIButton()
    self.startLabelButton = UIButton()
    self.endDateButton = UIButton()
    self.endLabelButton = UIButton()
    super.init(frame: CGRect.zero)
    self.isUserInteractionEnabled = true
    self.axis = NSLayoutConstraint.Axis.vertical
  }
  
  @available(*, unavailable)
  required init(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

public protocol DateButtonSetDelegate: AnyObject {
  func dateButtonTapped(isSelected: Bool)
}
