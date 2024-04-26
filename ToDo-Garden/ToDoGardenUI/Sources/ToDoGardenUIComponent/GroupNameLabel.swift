//
//  GroupNameLabel.swift
//
//
//  Created by Wood on 4/26/24.
//

import UIKit

import ToDoGardenUIResource

public final class GroupNameLabel: UILabel {
  public init() {
    super.init(frame: CGRect.zero)
    self.setupUI()
  }
  
  public required init?(coder: NSCoder) {
    super.init(coder: coder)
    self.setupUI()
  }
}

extension GroupNameLabel {
  private func setupUI() {
    self.setupTextStyle()
  }
  
  private func setupTextStyle() {
    self.font = UIFont.pretendardBodyBold
    self.textColor = UIColor.toDoGardenGreenDark
  }
}
