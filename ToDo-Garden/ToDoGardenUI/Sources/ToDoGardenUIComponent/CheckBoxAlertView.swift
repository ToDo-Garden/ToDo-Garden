//
//  CheckBoxAlertView.swift
//  ToDoGardenUI
//
//  Created by SONG on 3/10/25.
//

import UIKit

import ToDoGardenUIConstant
import ToDoGardenUIResource

// swiftlint:disable function_body_length
// MARK: dimmed 효과가 함께 적용되어 있습니다. 콜러측에서 addSubview하고 화면 전체로 레이아웃 맞춰주세요.
final public class CheckBoxAlertView: UIView {
  public var leftTapped: ((Bool) -> Void)?
  public var rightTapped: ((Bool) -> Void)?
  
  private let containerView: UIView
  private let messageLabel: UILabel
  private let checkBoxRow: TermsAgreementViewRow
  private let verticalStackView: UIStackView
  private let horizontalStackView: UIStackView
  private let leftButton: UIButton
  private let rightButton: UIButton
  
  private let leftButtonText: String
  private let rightButtonText: String
  
  typealias StringLiteral = Constant.CheckBoxAlertView.StringLiteral
  typealias Layout = Constant.CheckBoxAlertView.Layout
  
  init(
    mainMessage: String = StringLiteral.mainMessage,
    checkBoxMessage: String = StringLiteral.checkBoxMessage,
    leftButtonText: String = StringLiteral.cancelButtonTitle,
    rightButtonText: String = StringLiteral.settingButtonTitle
  ) {
    self.leftButtonText = leftButtonText
    self.rightButtonText = rightButtonText
    self.checkBoxRow = TermsAgreementViewRow(
      title: checkBoxMessage,
      font: UIFont.pretendardDetailRegular12,
      chevronIsHidden: true
    )
    self.containerView = UIView()
    self.messageLabel = UILabel()
    self.verticalStackView = UIStackView()
    self.horizontalStackView = UIStackView()
    self.leftButton = UIButton(type: .system)
    self.rightButton = UIButton(type: .system)
    
    super.init(frame: UIScreen.main.bounds)
    
    self.setupView(message: mainMessage)
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupView(message: String) {
    self.backgroundColor = UIColor.black.withAlphaComponent(Layout.backgroundAlpha)
    self.setupContainerView()
    self.setupMessageLabel(with: message)
    self.setupButtons()
    self.setupStackViews()
    self.setupCheckBoxView()
  }
  
  private func setupContainerView() {
    self.containerView.backgroundColor = .white
    self.containerView.layer.cornerRadius = Layout.containerCornerRadius
    self.containerView.layer.masksToBounds = true
    
    self.addSubview(self.containerView)
    self.containerView.usingAutolayout()
    NSLayoutConstraint.activate([
      self.containerView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
      self.containerView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
      self.containerView.widthAnchor.constraint(equalToConstant: Layout.containerWidth),
      self.containerView.heightAnchor.constraint(greaterThanOrEqualToConstant: Layout.containerMinHeight)
    ])
  }
  
  private func setupMessageLabel(with text: String) {
    self.messageLabel.text = text
    self.messageLabel.textAlignment = .center
    self.messageLabel.numberOfLines = Int.zero
    self.messageLabel.font = UIFont.pretendardBodySemiBold15
    self.messageLabel.textColor = UIColor.toDoGardenGreenDark
  }
  
  private func setupButtons() {
    self.leftButton.setTitle(self.leftButtonText, for: .normal)
    self.leftButton.setTitleColor(.gray, for: .normal)
    self.leftButton.addAction(UIAction { [weak self] _ in
      guard let self = self else { return }
      self.leftTapped?(self.checkBoxRow.isSelected)
    }, for: .touchUpInside)
    
    self.rightButton.setTitle(self.rightButtonText, for: .normal)
    self.rightButton.setTitleColor(.toDoGardenGreenDark, for: .normal)
    self.rightButton.addAction(UIAction { [weak self] _ in
      guard let self = self else { return }
      self.rightTapped?(self.checkBoxRow.isSelected)
    }, for: .touchUpInside)
  }
  
  private func setupStackViews() {
    self.verticalStackView.axis = .vertical
    self.verticalStackView.spacing = Layout.verticalSpacing
    self.verticalStackView.addArrangedSubview(self.messageLabel)
    self.verticalStackView.alignment = .center
    self.verticalStackView.backgroundColor = .white
    
    self.horizontalStackView.axis = .horizontal
    self.horizontalStackView.distribution = .fillEqually
    self.horizontalStackView.spacing = Layout.horizontalSpacing
    self.horizontalStackView.addArrangedSubview(self.leftButton)
    self.horizontalStackView.addArrangedSubview(self.rightButton)
    
    self.containerView.addSubview(self.verticalStackView)
    self.containerView.addSubview(self.horizontalStackView)
    
    self.verticalStackView.usingAutolayout()
    self.horizontalStackView.usingAutolayout()
    
    NSLayoutConstraint.activate([
      self.verticalStackView.topAnchor.constraint(
        equalTo: self.containerView.topAnchor,
        constant: Layout.verticalStackTopPadding
      ),
      self.verticalStackView.leadingAnchor.constraint(
        equalTo: self.containerView.leadingAnchor,
        constant: Layout.horizontalPadding
      ),
      self.verticalStackView.trailingAnchor.constraint(
        equalTo: self.containerView.trailingAnchor,
        constant: -Layout.horizontalPadding
      ),
      
      self.horizontalStackView.topAnchor.constraint(
        equalTo: self.verticalStackView.bottomAnchor,
        constant: Layout.buttonTopPadding
      ),
      self.horizontalStackView.leadingAnchor.constraint(
        equalTo: self.containerView.leadingAnchor,
        constant: Layout.horizontalPadding
      ),
      self.horizontalStackView.trailingAnchor.constraint(
        equalTo: self.containerView.trailingAnchor,
        constant: -Layout.horizontalPadding
      ),
      self.horizontalStackView.bottomAnchor.constraint(
        equalTo: self.containerView.bottomAnchor,
        constant: -Layout.buttonBottomPadding
      ),
      self.horizontalStackView.heightAnchor.constraint(equalToConstant: Layout.buttonHeight)
    ])
  }
  
  private func setupCheckBoxView() {
    self.addSubview(self.checkBoxRow)
    self.checkBoxRow.usingAutolayout()
    
    NSLayoutConstraint.activate([
      self.checkBoxRow.heightAnchor.constraint(equalToConstant: Layout.checkBoxHeight),
      self.checkBoxRow.widthAnchor.constraint(greaterThanOrEqualToConstant: Layout.checkBoxWidth),
      self.checkBoxRow.topAnchor.constraint(equalTo: self.verticalStackView.bottomAnchor),
      self.checkBoxRow.leadingAnchor.constraint(
        equalTo: self.verticalStackView.leadingAnchor,
        constant: Layout.checkBoxLeadingPadding
      )
    ])
  }
}
// swiftlint:enable function_body_length

#if DEBUG
@available(iOS 17.0, *)
#Preview {
  let view = CheckBoxAlertView()
  view.leftTapped = { isChecked in
    print("Left tapped")
  }
  return view
}
#endif
