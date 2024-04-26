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
  private var additionalContentSize: CGSize

  public override var intrinsicContentSize: CGSize {
    var contentSize = super.intrinsicContentSize
    contentSize.width += self.additionalContentSize.width
    contentSize.height += self.additionalContentSize.height
    return contentSize
  }

  public init() {
    self.textPadding = UIEdgeInsets()
    self.additionalContentSize = CGSize()
    super.init(frame: CGRect.zero)
    self.setupUI()
  }
  
  public required init?(coder: NSCoder) {
    self.textPadding = UIEdgeInsets()
    self.additionalContentSize = CGSize()
    super.init(coder: coder)
    self.setupUI()
  }
  
  public override func drawText(in rect: CGRect) {
    super.drawText(
      in: rect.inset(
        by: self.textPadding
      )
    )
  }

  public func setupTitle(with text: String) {
    self.text = text
  }
}

extension GroupNameLabel {
  private func setupUI() {
    self.setupTextPadding()
    self.setupAdditionalContentSize()
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
  
  private func setupAdditionalContentSize() {
    let additionalContentWidth: CGFloat = Constant.GroupNameLabel.Layout.TextPadding.left
    + Constant.GroupNameLabel.Layout.TextPadding.right
    self.additionalContentSize.width = additionalContentWidth
    
    let additionalContentHeight: CGFloat = Constant.GroupNameLabel.Layout.TextPadding.top
    + Constant.GroupNameLabel.Layout.TextPadding.bottom
    self.additionalContentSize.height = additionalContentHeight
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
