//
//  InputTextValidationView.swift
//
//
//  Created by Wood on 9/26/24.
//

import UIKit

import ToDoGardenUIConstant

public final class InputTextValidationView: UIView {
  private let model: Model
  private let textInputView: TextInputView

  public init(model: Model) {
    self.model = model
    self.textInputView = TextInputView(model: model.inputText)
    super.init(frame: CGRect.zero)
    self.setupUI()
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: - Set up UI

extension InputTextValidationView {
  private func setupUI() {
    self.setupSubviewsLayout()
  }
}

// MARK: - Set up Layout

extension InputTextValidationView {
  private func setupSubviewsLayout() {
    self.setupTextInputViewLayout()
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

  return stackView
}
#endif
