import UIKit

import ToDoGardenUIConstant

public final class TextInputView: UIView {
  private let model: Model
  private let inputTextField: Styled.TextField
  private let placeholderLabel: UILabel
  private let placeholderText: String

  public init(model: Model) {
    self.model = model
    self.inputTextField = Styled.TextField(configuration: .groupEdit(.standard))
    self.placeholderLabel = UILabel()
    self.placeholderText = model.inputText + Constant.TextInputView.StringLiteral.placeholderText
    super.init(frame: CGRect.zero)
    self.setup()
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: Private Functions

extension TextInputView {
  private func setup() {
    self.setupPlaceholderLabel()
    self.addSubviews()
    self.setupSubviewsLayout()
  }

  private func setupPlaceholderLabel() {
    self.placeholderLabel.font = UIFont.pretendardBodySemiBold15
    self.placeholderLabel.text = self.placeholderText
    self.placeholderLabel.textColor = UIColor.toDoGardenGray2
    self.placeholderLabel.adjustsFontSizeToFitWidth = true
  }
}

// MARK: Auto Layout

extension TextInputView {
  private func addSubviews() {
    self.addSubview(self.inputTextField)
    self.addSubview(self.placeholderLabel)
  }

  private func setupSubviewsLayout() {
    self.setupInputTextFieldLayout()
    self.setupPlaceholderLabelLayout()
  }

  private func setupInputTextFieldLayout() {
    self.inputTextField.usingAutolayout()

    NSLayoutConstraint.activate(
      [
        self.inputTextField.leadingAnchor.constraint(equalTo: self.leadingAnchor),
        self.inputTextField.trailingAnchor.constraint(equalTo: self.trailingAnchor),
        self.inputTextField.bottomAnchor.constraint(equalTo: self.bottomAnchor)
      ]
    )
  }

  private func setupPlaceholderLabelLayout() {
    self.placeholderLabel.usingAutolayout()

    NSLayoutConstraint.activate(
      [
        self.placeholderLabel.topAnchor.constraint(equalTo: self.inputTextField.topAnchor),
        self.placeholderLabel.leadingAnchor.constraint(equalTo: self.inputTextField.leadingAnchor),
        self.placeholderLabel.trailingAnchor.constraint(lessThanOrEqualTo: self.inputTextField.trailingAnchor),
        self.placeholderLabel.bottomAnchor.constraint(
          equalTo: self.inputTextField.bottomAnchor,
          constant: Constant.TextInputView.Layout.PlaceholderLabel.bottomMargin
        )
      ]
    )
  }
}

// MARK: Model

extension TextInputView {
  public struct Model {
    let inputText: String
    let shrinkScale: CGFloat

    public init(inputText: String, shrinkScale: CGFloat = 0.8) {
      self.inputText = inputText
      self.shrinkScale = shrinkScale
    }

    public static let toDoName = Self(inputText: "할 일")
    public static let groupName = Self(inputText: "그룹명")
    public static let userNickname = Self(inputText: "닉네임")
    public static let userId = Self(inputText: "아이디")
    public static let userDescription = Self(inputText: "소개")
  }
}
