//
//  InputTextValidationView.swift
//
//
//  Created by Wood on 9/26/24.
//

import UIKit

import ToDoGardenUIConstant
import ToDoGardenUIResource

public final class InputTextValidationView: UIView {
  private let model: Model
  private let textInputView: TextInputView
  private let validationTextLabel: UILabel

  private var validationTextLabelTopConstraint: NSLayoutConstraint?

  public init(model: Model) {
    self.model = model
    self.textInputView = TextInputView(model: model.inputText)
    self.validationTextLabel = UILabel()
    super.init(frame: CGRect.zero)
    self.setupUI()
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  public func showValidationText() {
    self.moveValidationTextLabel(isShowing: true)
  }

  public func hideValidationText() {
    self.moveValidationTextLabel(isShowing: false)
  }
}

// MARK: - Validation Text Moving Animation

extension InputTextValidationView {
  private func moveValidationTextLabel(isShowing: Bool) {
    let constant = Constant.InputTextValidationView.Animation.self
    let asdf = isShowing == false ? constant.hideTopMargin : constant.showTopMargin
    UIView.animate(withDuration: constant.duration) {
      self.validationTextLabelTopConstraint?.constant = asdf
      self.superview?.layoutIfNeeded()
    }
  }
}

// MARK: - Set up UI

extension InputTextValidationView {
  private func setupUI() {
    self.setupValidationTextLabel()
    self.setupSubviewsLayout()
  }

  private func setupValidationTextLabel() {
    self.validationTextLabel.textColor = UIColor.toDoGardenEditButtonRed
    self.validationTextLabel.font = UIFont.pretendardDetailRegular12
    self.validationTextLabel.textAlignment = NSTextAlignment.right
    self.validationTextLabel.numberOfLines = 2
    self.validationTextLabel.text = self.model.validationText
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

// MARK: - Model

public extension InputTextValidationView {
  struct Model {
    public let inputText: TextInputView.Model
    public let validationText: String

    public init(inputText: String, validationText: String) {
      self.inputText = TextInputView.Model(inputText: inputText)
      self.validationText = validationText
    }

    public static let id = Self(
      inputText: TextInputView.Model.userId.inputText,
      validationText: Constant.InputTextValidationView.StringLiteral.ValidationText.invalidID
    )
    public static let nickname = Self(
      inputText: TextInputView.Model.userNickname.inputText,
      validationText: Constant.InputTextValidationView.StringLiteral.ValidationText.invalidNickname
    )
    public static let introduction = Self(
      inputText: TextInputView.Model.userDescription.inputText,
      validationText: Constant.InputTextValidationView.StringLiteral.ValidationText.invalidIntroduction
    )
  }
}

#if DEBUG
@available(iOS 17.0, *)
#Preview {
  let stackView = UIStackView()
  stackView.axis = .vertical
  stackView.spacing = 150
  stackView.distribution = .equalSpacing
  stackView.usingAutolayout()
  stackView.widthAnchor.constraint(equalToConstant: 300).isActive = true

  let idView = InputTextValidationView(model: InputTextValidationView.Model.id)
  stackView.addArrangedSubview(idView)

  let nickNameView = InputTextValidationView(model: InputTextValidationView.Model.nickname)
  stackView.addArrangedSubview(nickNameView)

  let introductionView = InputTextValidationView(model: InputTextValidationView.Model.introduction)
  stackView.addArrangedSubview(introductionView)

  introductionView.showValidationText()

  Task {
    try? await Task.sleep(2_000_000_000)
    idView.showValidationText()

    try? await Task.sleep(2_000_000_000)
    idView.hideValidationText()
  }

  return stackView
}
#endif
