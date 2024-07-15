import UIKit

import ToDoGardenUIAPI
import ToDoGardenUIConstant

public final class TextInputView: UIView, TextInputViewAPI {
  private let model: Model
  private let inputTextField: Styled.TextField
  private let placeholderLabel: UILabel
  private var placeholderText: String

  private var height: CGFloat {
    let textFieldDefatulLineHeight = Constant.TextInputView.Layout.InputTextField.defaultHeight
    let textFieldHeight = self.inputTextField.font?.lineHeight ?? textFieldDefatulLineHeight

    let labelDefatulLineHeight = Constant.TextInputView.Layout.PlaceholderLabel.defaultHeight
    let labelHeight = self.placeholderLabel.font?.lineHeight ?? labelDefatulLineHeight
    return textFieldHeight + labelHeight + 1
  }

  public override var intrinsicContentSize: CGSize {
    return CGSize(width: 0, height: self.height)
  }

  public init(model: Model) {
    self.model = model
    self.inputTextField = Styled.TextField(
      configuration: Styled.TextField.Configuration.groupEdit(
        Styled.TextField.Configuration.GroupEditModel.standard
      )
    )
    self.placeholderLabel = UILabel()
    self.placeholderText = ""
    super.init(frame: CGRect.zero)
    self.setup()
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  public func changeBottomLine(color: UIColor) {
    self.inputTextField.mainColor = color
  }

  public func setBeginEditing(with text: String) {
    guard self.inputTextField.isFirstResponder == false
    else { return }

    self.inputTextField.text = text
    _ = self.inputTextField.becomeFirstResponder()
  }

  public func getEditingText() -> String? {
    return self.inputTextField.text
  }
}

// MARK: Private Functions

extension TextInputView {
  private func setup() {
    self.setupInputTextUI()
    self.setupPlaceholderText()
    self.setupPlaceholderLabel()
    self.setupInputTextFieldDelegate()
    self.addSubviews()
    self.setupSubviewsLayout()
  }

  private func setupInputTextUI() {
    self.inputTextField.textColor = UIColor.toDoGardenBlack
    self.inputTextField.font = UIFont.pretendardBodyRegular
  }

  private func setupPlaceholderText() {
    self.placeholderText = self.makePlaceholderText()
  }

  private func makePlaceholderText() -> String {
    guard let lastCharacter = self.model.inputText.last
    else { return self.model.inputText + Constant.TextInputView.StringLiteral.defaultPlaceholderSuffix }

    let consonants = String(lastCharacter).decomposedStringWithCompatibilityMapping.unicodeScalars
    if consonants.count >= 3 {
      return self.model.inputText + Constant.TextInputView.StringLiteral.suffixWithFinalConsonant
    } else {
      return self.model.inputText + Constant.TextInputView.StringLiteral.suffixWithoutFinalConsonant
    }
  }

  private func setupPlaceholderLabel() {
    self.placeholderLabel.font = UIFont.pretendardBodySemiBold15
    self.placeholderLabel.text = self.placeholderText
    self.placeholderLabel.textColor = UIColor.toDoGardenGray2
    self.placeholderLabel.adjustsFontSizeToFitWidth = true
  }

  private func setupInputTextFieldDelegate() {
    self.inputTextField.delegate = self
  }
}

// MARK: TextField Delegate Functions

extension TextInputView: UITextFieldDelegate {
  public func textFieldDidBeginEditing(_ textField: UITextField) {
    self.updatePlaceholderLabelText(isEditing: true)
    self.updatePlaceholderLabelPosition(isEditing: true)
  }

  public func textFieldDidEndEditing(_ textField: UITextField) {
    guard self.inputTextField.text?.isEmpty == true
    else { return }

    self.updatePlaceholderLabelText(isEditing: false)
    self.updatePlaceholderLabelPosition(isEditing: false)
  }

  private func updatePlaceholderLabelText(isEditing: Bool) {
    let text = isEditing ? self.model.inputText : self.placeholderText
    self.placeholderLabel.text = text

    let textColor = isEditing ? UIColor.toDoGardenGreenDark : UIColor.toDoGardenGray2
    self.placeholderLabel.textColor = textColor
  }

  private func updatePlaceholderLabelPosition(isEditing: Bool) {
    let transform = self.makePlaceholderLabelTrasnform(isEditing: isEditing, scale: self.model.shrinkScale)
    if isEditing == false {
      self.placeholderLabel.transform = transform
    }

    let duration = Constant.TextInputView.Animation.duration
    UIView.animate(withDuration: duration, delay: 0.0) {
      let animationTransform = isEditing ? transform : CGAffineTransform.identity
      self.placeholderLabel.transform = animationTransform
    }
  }

  private func makePlaceholderLabelTrasnform(isEditing: Bool, scale: CGFloat) -> CGAffineTransform {
    let leadingMargin = -self.placeholderLabel.font.pointSize * (1 - scale)
    let totalMargin = isEditing ? leadingMargin : leadingMargin * 4
    let offsetX = self.placeholderLabel.bounds.origin.x + totalMargin

    let labelHeight = -self.placeholderLabel.bounds.height
    let defaultLineHeight = Constant.TextInputView.Layout.InputTextField.defaultHeight
    let textFieldLineHeight = self.inputTextField.font?.lineHeight ?? defaultLineHeight
    let offsetY = labelHeight == 0 ? -textFieldLineHeight : labelHeight

    return CGAffineTransform(translationX: offsetX, y: offsetY).scaledBy(x: scale, y: scale)
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
          constant: -Constant.TextInputView.Layout.PlaceholderLabel.bottomMargin
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

    public static let toDoName = Self(inputText: Constant.TextInputView.StringLiteral.Model.toDoName)
    public static let groupName = Self(inputText: Constant.TextInputView.StringLiteral.Model.groupName)
    public static let userNickname = Self(inputText: Constant.TextInputView.StringLiteral.Model.userNickname)
    public static let userId = Self(inputText: Constant.TextInputView.StringLiteral.Model.userId)
    public static let userDescription = Self(inputText: Constant.TextInputView.StringLiteral.Model.userDescription)
  }
}

#if DEBUG
@available(iOS 17.0, *)
#Preview {
  let stackView = UIStackView()
  stackView.axis = .vertical
  stackView.spacing = 50

  let toDoNameView = TextInputView(model: TextInputView.Model.toDoName)
  stackView.addArrangedSubview(toDoNameView)

  let groupNameView = TextInputView(model: TextInputView.Model.groupName)
  groupNameView.changeBottomLine(color: UIColor.toDoGardenYellow)
  stackView.addArrangedSubview(groupNameView)

  let userIdInputView = TextInputView(model: TextInputView.Model.userId)
  userIdInputView.setBeginEditing(with: "우드")
  stackView.addArrangedSubview(userIdInputView)

  return stackView
}
#endif
