import UIKit

import ToDoGardenUIAPI
import ToDoGardenUIConstant

public final class TextInputView: UIView, TextInputViewAPI {
  private let inputText: String
  private let placeholderText: String

  private let inputTextField: Styled.TextField
  private let placeholderLabel: UILabel

  public weak var delegate: TextInputViewDelegate?

  private var height: CGFloat {
    let layout = Constant.TextInputView.Layout.self
    let textFieldDefatulLineHeight = layout.InputTextField.defaultHeight
    let textFieldHeight = self.inputTextField.font?.lineHeight ?? textFieldDefatulLineHeight

    let labelDefatulLineHeight = layout.PlaceholderLabel.defaultHeight
    let labelHeight = self.placeholderLabel.font?.lineHeight ?? labelDefatulLineHeight
    let bottomLineTopMargin = layout.InputTextField.bottomLineTopMargin
    return textFieldHeight + labelHeight + bottomLineTopMargin
  }

  public override var intrinsicContentSize: CGSize {
    return CGSize(width: 0, height: self.height)
  }

  public override var isFirstResponder: Bool {
    return self.inputTextField.isFirstResponder
  }

  public init(inputText: String, placeholderText: String) {
    self.inputTextField = Styled.TextField(
      configuration: Styled.TextField.Configuration.groupEdit(
        Styled.TextField.Configuration.GroupEditModel.standard
      )
    )
    self.placeholderLabel = UILabel()
    self.inputText = inputText
    self.placeholderText = placeholderText
    super.init(frame: CGRect.zero)
    self.setup()
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  public override func resignFirstResponder() -> Bool {
    super.resignFirstResponder()
    return self.inputTextField.resignFirstResponder()
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
    self.setupMainUI()
    self.setupInputTextUI()
    self.setupReturnButtonType()
    self.setupPlaceholderLabel()
    self.setupInputTextFieldDelegate()
    self.addSubviews()
    self.setupSubviewsLayout()
  }

  private func setupMainUI() {
    self.backgroundColor = UIColor.toDoGardenWhite
    self.clipsToBounds = true
  }

  private func setupInputTextUI() {
    self.inputTextField.textColor = UIColor.toDoGardenBlack
    self.inputTextField.font = UIFont.pretendardBodyRegular
  }

  private func setupReturnButtonType() {
    self.inputTextField.returnKeyType = UIReturnKeyType.done
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

  public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
  
  public func textFieldDidChangeSelection(_ textField: UITextField) {
    self.delegate?.textInputViewDidChange()
  }

  private func updatePlaceholderLabelText(isEditing: Bool) {
    let text = isEditing ? self.inputText : self.placeholderText
    self.placeholderLabel.text = text

    let textColor = isEditing ? UIColor.toDoGardenGreenDark : UIColor.toDoGardenGray2
    self.placeholderLabel.textColor = textColor
  }

  private func updatePlaceholderLabelPosition(isEditing: Bool) {
    let constant = Constant.TextInputView.Animation.self
    let transform = self.makePlaceholderLabelTrasnform(isEditing: isEditing, scale: constant.shrinkScale)
    if isEditing == false {
      self.placeholderLabel.transform = transform
    }

    UIView.animate(withDuration: constant.duration, delay: 0.0) {
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
        self.inputTextField.bottomAnchor.constraint(
          equalTo: self.bottomAnchor,
          constant: -Constant.TextInputView.Layout.InputTextField.bottomLineTopMargin
        )
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

#if DEBUG
@available(iOS 17.0, *)
#Preview {
  let stackView = UIStackView()
  stackView.axis = .vertical
  stackView.spacing = 50

  let constant = Constant.TextInputView.StringLiteral.self
  let toDoNameView = TextInputView(
    inputText: constant.UserID.inputText,
    placeholderText: constant.UserID.placeholderText
  )
  stackView.addArrangedSubview(toDoNameView)

  let groupNameView = TextInputView(
    inputText: constant.UserName.inputText,
    placeholderText: constant.UserName.placeholderText
  )
  stackView.addArrangedSubview(groupNameView)

  let groupNameInputView = TextInputView(
    inputText: constant.GroupName.inputText,
    placeholderText: constant.GroupName.placeholderText
  )
  stackView.addArrangedSubview(groupNameInputView)

  let userIntroductionInputView = TextInputView(
    inputText: constant.UserIntroduction.inputText,
    placeholderText: constant.UserIntroduction.placeholderText
  )
  stackView.addArrangedSubview(userIntroductionInputView)

  return stackView
}
#endif
