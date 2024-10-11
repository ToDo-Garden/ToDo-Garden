//
//  SignUpInputView.swift
//
//
//  Created by SONG on 10/10/24.
//

import UIKit

import ToDoGardenUIConstant

public final class SignUpInputView: UIView {
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
    let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
    let screenWidth = windowScene?.screen.bounds.width ?? CGFloat.zero
    let screenHeight = windowScene?.screen.bounds.height ?? CGFloat.zero
    return CGSize(
      width: screenWidth,
      height: screenHeight * Constant.SignUpInputView.heightMultiplier
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

@available(iOS 17.0, *)
#Preview {
  let view = SignUpInputView(
    firstTitle: "환영해요!",
    secondTitle: "아이디를 정해볼까요?",
    thirdTitle: "아이디로 친구의 가든을 찾을 수 있어요.",
    textFieldTitle: "아이디",
    placeholderText: "아이디를 입력해주세요.",
    validationText: "아이디는 5~12자 내외 띄어쓰기 없이\n영문, 숫자만 사용 가능합니다"
  )
  
  view.startTitleAnimation()
  DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
    view.textInputView.showValidationText()
  }
  
  DispatchQueue.main.asyncAfter(deadline: .now() + 6) {
    view.textInputView.hideValidationText()
  }
  return view
}
