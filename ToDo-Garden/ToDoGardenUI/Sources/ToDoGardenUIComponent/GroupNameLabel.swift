//
//  GroupNameLabel.swift
//
//
//  Created by Wood on 4/26/24.
//

import UIKit

import ToDoGardenUIConstant
import ToDoGardenUIResource

public final class GroupNameLabel: UILabel {
  private var textPadding: UIEdgeInsets

  public init() {
    self.textPadding = UIEdgeInsets()
    super.init(frame: CGRect.zero)
    self.setupUI()
  }
  
  public required init?(coder: NSCoder) {
    self.textPadding = UIEdgeInsets()
    super.init(coder: coder)
    self.setupUI()
  }
}

extension GroupNameLabel {
  private func setupUI() {
    self.setupTextPadding()
    self.setupTextStyle()
    self.setupBackgroundColor()
    self.setupRoundedCorner()
  }

  private func setupTextPadding() {
    self.textPadding = UIEdgeInsets(
      top: Constant.GroupNameLabel.Layout.TextPadding.top,
      left: Constant.GroupNameLabel.Layout.TextPadding.left,
      bottom: Constant.GroupNameLabel.Layout.TextPadding.bottom,
      right: Constant.GroupNameLabel.Layout.TextPadding.right
    )
  }

  private func setupTextStyle() {
    self.font = UIFont.pretendardBodyBold
    self.textColor = UIColor.toDoGardenGreenDark
  }
  
  private func setupBackgroundColor() {
    self.backgroundColor = UIColor.toDoGardenGreenBackground
  }
  
  private func setupRoundedCorner() {
    self.clipsToBounds = true
    self.layer.cornerRadius = Constant.GroupNameLabel.Layout.Layer.cornerRadius
  }
}
