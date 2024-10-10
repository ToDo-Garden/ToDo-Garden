//
//  SignUpInputView.swift
//
//
//  Created by SONG on 10/10/24.
//

import UIKit

import ToDoGardenUIConstant

public class SignUpInputView: UIView {
  private let titleView: AnimatedMultiLinesTitleView
  
  public let textInputView: InputTextValidationView
  
  public init(
    firstTitle: String,
    secondTitle: String,
    thirdTitle: String,
    textFieldTitle: String,
    placeholderText: String,
    validationText: String
  ) {
    self.titleView = AnimatedMultiLinesTitleView(
      firstLineText: firstTitle,
      secondLineText: secondTitle,
      thirdLineText: thirdTitle
    )
    self.textInputView = InputTextValidationView(
      inputText: textFieldTitle,
      placeholderText: placeholderText,
      validationText: validationText
    )
    super.init(frame: CGRect.zero)
    self.backgroundColor = UIColor.white
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  public override var intrinsicContentSize: CGSize {
    return CGSize(
      width: UIScreen.main.bounds.width,
      height: UIScreen.main.bounds.height * Constant.SignUpInputView.heightMultiplier
    )
  }
}
