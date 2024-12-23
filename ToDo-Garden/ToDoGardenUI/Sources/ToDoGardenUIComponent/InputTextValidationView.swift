//
//  InputTextValidationView.swift
//
//
//  Created by Wood on 9/26/24.
//

import UIKit

import ToDoGardenUIAPI
import ToDoGardenUIConstant
import ToDoGardenUIResource

public final class InputTextValidationView: UIView {
  private let textInputView: TextInputView
  private let validationTextLabel: UILabel

  private var validationTextLabelTopConstraint: NSLayoutConstraint?

  public weak var delegate: InputTextValidationViewDelegate?

  public override var intrinsicContentSize: CGSize {
    return self.caluclateIntrinsicContentSize()
  }

  public init(
    inputText: String,
    placeholderText: String,
    validationText: String
  ) {
    self.textInputView = TextInputView(inputText: inputText, placeholderText: placeholderText)
    self.validationTextLabel = UILabel()
    super.init(frame: CGRect.zero)
    self.setupUI(with: validationText)
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  public func setBeginEditing(with text: String) {
    self.textInputView.setBeginEditing(with: text)
  }

  public func getEditingText() -> String? {
    return textInputView.getEditingText()
  }

  public func showValidationText() {
    self.moveValidationTextLabel(isShowing: true)
  }

  public func hideValidationText() {
    self.moveValidationTextLabel(isShowing: false)
  }

  public func changeValidationText(_ text: String) {
    self.validationTextLabel.text = text
  }
  
  public func setBecomeFirstRespoder() {
    self.textInputView.setBecomeFirstResoponder()
  }
  
  public func setResignFirstResponder() {
    self.textInputView.setResignFirstResponder()
  }
}

// MARK: - Validation Text Moving Animation

extension InputTextValidationView {
  private func moveValidationTextLabel(isShowing: Bool) {
    let constant = Constant.InputTextValidationView.Animation.self
    let topMargin = isShowing == false ? constant.hideTopMargin : constant.showTopMargin
    UIView.animate(withDuration: constant.duration) {
      self.validationTextLabelTopConstraint?.constant = topMargin
      self.superview?.layoutIfNeeded()
    }
  }
}

// MARK: - Set up UI

extension InputTextValidationView {
  private func setupUI(with validationText: String) {
    self.setupValidationTextLabel(with: validationText)
    self.setupTextInputViewDelegate()
    self.setupSubviewsLayout()
  }

  private func setupValidationTextLabel(with validationText: String) {
    self.validationTextLabel.textColor = UIColor.toDoGardenEditButtonRed
    self.validationTextLabel.font = UIFont.pretendardDetailRegular12
    self.validationTextLabel.textAlignment = NSTextAlignment.right
    self.validationTextLabel.numberOfLines = 2
    self.validationTextLabel.text = validationText
  }

  private func caluclateIntrinsicContentSize() -> CGSize {
    var contentSize = CGSize()
    contentSize.width = Constant.InputTextValidationView.Layout.width
    contentSize.height += self.textInputView.intrinsicContentSize.height
    contentSize.height += Constant.InputTextValidationView.Layout.validationTextHeight
    return contentSize
  }
}

// MARK: - Delegate Functions

public protocol InputTextValidationViewDelegate: AnyObject {
  func inputTextDidChanged(_ text: String?)
}

extension InputTextValidationView: TextInputViewDelegate {
  public func textInputViewDidChange() {
    let text = self.textInputView.getEditingText()
    self.delegate?.inputTextDidChanged(text)
  }

  private func setupTextInputViewDelegate() {
    self.textInputView.delegate = self
  }
}

// MARK: - Set up Layout

extension InputTextValidationView {
  private func setupSubviewsLayout() {
    self.setupTextInputViewLayout()
    self.setupValidationTextLabelLayout()
  }

  private func setupTextInputViewLayout() {
    self.addSubview(self.textInputView)
    self.textInputView.usingAutolayout()

    NSLayoutConstraint.activate(
      [
        self.textInputView.topAnchor.constraint(equalTo: self.topAnchor),
        self.textInputView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
        self.textInputView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
      ]
    )
  }

  private func setupValidationTextLabelLayout() {
    self.addSubview(self.validationTextLabel)
    self.sendSubviewToBack(self.validationTextLabel)
    self.validationTextLabel.usingAutolayout()

    self.validationTextLabelTopConstraint = self.validationTextLabel.topAnchor.constraint(
      equalTo: self.textInputView.topAnchor
    )
    self.validationTextLabelTopConstraint?.isActive = true
    
    NSLayoutConstraint.activate(
      [
        self.validationTextLabel.leadingAnchor.constraint(lessThanOrEqualTo: self.textInputView.leadingAnchor),
        self.validationTextLabel.trailingAnchor.constraint(equalTo: self.textInputView.trailingAnchor)
      ]
    )
  }
}

#if DEBUG
@available(iOS 17.0, *)
#Preview {
  let stackView = UIStackView()
  stackView.axis = .vertical
  stackView.spacing = 50
  stackView.distribution = .equalSpacing
  stackView.usingAutolayout()

  let idView = InputTextValidationView(
    inputText: "아이디",
    placeholderText: "아이디를 입력해주세요.",
    validationText: "아이디는 5~12자 내외 띄어쓰기 없이\n영문, 숫자만 사용 가능합니다"
  )
  stackView.addArrangedSubview(idView)
  idView.showValidationText()

  let existedIdView = InputTextValidationView(
    inputText: "아이디",
    placeholderText: "아이디를 입력해주세요.",
    validationText: "아이디는 5~12자 내외 띄어쓰기 없이\n영문, 숫자만 사용 가능합니다"
  )
  stackView.addArrangedSubview(existedIdView)
  existedIdView.changeValidationText("이미 사용중인 아이디입니다")
  existedIdView.showValidationText()

  let nickNameView = InputTextValidationView(
    inputText: "닉네임",
    placeholderText: "닉네임을 입력해주세요.",
    validationText: "닉네임은 5~12자 내외\n띄어쓰기, 특수기호 없이 사용 가능합니다"
  )
  stackView.addArrangedSubview(nickNameView)
  nickNameView.showValidationText()

  let introductionView = InputTextValidationView(
    inputText: "소개",
    placeholderText: "당신을 소개해주세요.",
    validationText: "한줄소개는 최대 15글자까지 사용 가능합니다"
  )
  stackView.addArrangedSubview(introductionView)
  introductionView.showValidationText()

  return stackView
}
#endif
