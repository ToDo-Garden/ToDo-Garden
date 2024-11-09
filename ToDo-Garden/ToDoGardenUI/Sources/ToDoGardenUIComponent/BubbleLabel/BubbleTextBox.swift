//
//  BubbleTextBox.swift
//
//
//  Created by SONG on 11/9/24.
//

import UIKit

import ToDoGardenUIConstant
import ToDoGardenUIResource

final class BubbleTextBox: UIView {
  private let textLabel: UILabel
  let cancelButton: UIButton
  
  init(iconImage: UIImage, text: String) {
    self.textLabel = UILabel()
    self.cancelButton = UIButton()
    super.init(frame: CGRect.zero)
    self.backgroundColor = UIColor.white
    self.layer.borderWidth = 2
    self.layer.borderColor = UIColor.toDoGardenGreenDark.cgColor
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override var intrinsicContentSize: CGSize {
    let verticalMargin = Constant.BubbleLabel.BubbleTextBox.commonMargin
    return CGSize(
      width: UIView.noIntrinsicMetric,
      height: self.textLabel.intrinsicContentSize.height + verticalMargin
    )
  }
}
