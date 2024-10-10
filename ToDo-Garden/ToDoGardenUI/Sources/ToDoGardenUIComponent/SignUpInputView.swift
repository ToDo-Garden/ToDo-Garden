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
    self.setupUI()
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
  
  @MainActor
  public func startTitleAnimation() {
    self.titleView.startAnimation()
  }
  
  @MainActor
  public func cancelTitleAnimation() {
    self.titleView.cancelTask()
  }
}

extension SignUpInputView {
  private func setupUI() {
    self.setupTextInputView()
    self.setupTitleView()
  }
  
  private func setupTextInputView() {
    let constants = Constant.SignUpInputView.TextInputView.self
    self.addSubview(self.textInputView)
    self.textInputView.usingAutolayout()
    NSLayoutConstraint.activate([
      self.textInputView.topAnchor.constraint(
        equalTo: self.topAnchor,
        constant: constants.topMargin
      ),
      self.textInputView.leadingAnchor.constraint(
        equalTo: self.leadingAnchor,
        constant: self.intrinsicContentSize.width * constants.leadingMultiplier
      ),
      self.textInputView.trailingAnchor.constraint(
        equalTo: self.trailingAnchor,
        constant: self.intrinsicContentSize.width * constants.trailingMultiplier
      )
    ])
  }
  
  private func setupTitleView() {
    self.addSubview(self.titleView)
    self.titleView.usingAutolayout()
    NSLayoutConstraint.activate([
      self.titleView.topAnchor.constraint(equalTo: self.topAnchor),
      self.titleView.leadingAnchor.constraint(equalTo: self.textInputView.leadingAnchor),
      self.titleView.trailingAnchor.constraint(lessThanOrEqualTo: self.textInputView.trailingAnchor)
    ])
  }
}
