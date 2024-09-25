//
//  TermsAgreementViewRow.swift
//
//
//  Created by SONG on 9/22/24.
//

import UIKit

import ToDoGardenUIConstant
import ToDoGardenUIResource

final class TermsAgreementViewRow: UIView {
  // MARK: - Properties
  let checkButton: UIButton
  private let textLabel: UILabel
  private let chevronButton: UIButton
  
  var isSelected: Bool {
    get { return self.checkButton.isSelected }
    set { self.checkButton.isSelected = newValue }
  }
  
  var chevronAction: (() -> Void)?
  
  override public var intrinsicContentSize: CGSize {
    return Constant.TermsAgreementViewRow.Layout.size
  }
  
  // MARK: - Initialization
  init(chevronButtonIsHidden: Bool) {
    self.checkButton = UIButton(type: UIButton.ButtonType.custom)
    self.textLabel = UILabel()
    self.chevronButton = UIButton(type: UIButton.ButtonType.system)
    
    super.init(frame: CGRect.zero)
    self.setupViews()
    self.chevronButton.isHidden = chevronButtonIsHidden
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError()
  }
  
  // MARK: - UISetup
  private func setupViews() {
    self.setupCheckButton()
    self.setupTextLabel()
    self.setupChevronButton()
    self.setupConstraints()
  }
  
  private func setupCheckButton() {
    self.checkButton.setImage(UIImage.circledCheckMarkEmpty, for: UIControl.State.normal)
    self.checkButton.setImage(UIImage.circledCheckMarkFill, for: UIControl.State.selected)
    self.checkButton.tintColor = UIColor.toDoGardenGreenDark
    self.checkButton.addAction(UIAction(handler: { [weak self] _ in
      self?.checkButtonTapped()
    }), for: UIControl.Event.touchUpInside)
  }
  
  private func setupTextLabel() {
    self.textLabel.font = UIFont.systemFont(
      ofSize: Constant.TermsAgreementViewRow.TextLabel.fontSize
    )
    self.textLabel.textColor = UIColor.toDoGardenGreenDark
  }
  
  private func setupChevronButton() {
    self.chevronButton.setImage(UIImage.forwardButtonImage, for: UIControl.State.normal)
    self.chevronButton.tintColor = UIColor.toDoGardenGreenDark
    self.chevronButton.addAction(UIAction(handler: { [weak self] _ in
      self?.chevronButtonTapped()
    }), for: UIControl.Event.touchUpInside)
  }
  
  private func setupConstraints() {
    self.setupCheckButtonConstraints()
    self.setupTextLabelConstraints()
    self.setupChevronButtonConstraints()
  }
  
  private func setupCheckButtonConstraints() {
    let length = Constant.TermsAgreementViewRow.CheckButton.Layout.length
    self.addSubview(checkButton)
    self.checkButton.usingAutolayout()
    NSLayoutConstraint.activate([
      self.checkButton.leadingAnchor.constraint(equalTo: leadingAnchor),
      self.checkButton.centerYAnchor.constraint(equalTo: centerYAnchor),
      self.checkButton.widthAnchor.constraint(equalToConstant: length),
      self.checkButton.heightAnchor.constraint(equalToConstant: length)
    ])
  }
  
  private func setupTextLabelConstraints() {
    self.addSubview(self.textLabel)
    self.textLabel.usingAutolayout()
    NSLayoutConstraint.activate([
      self.textLabel.leadingAnchor.constraint(
        equalTo: self.checkButton.trailingAnchor,
        constant: Constant.TermsAgreementViewRow.Layout.commonMargin
      ),
      self.textLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
      self.textLabel.widthAnchor.constraint(
        equalToConstant: Constant.TermsAgreementViewRow.TextLabel.Layout.width
      ),
      self.textLabel.heightAnchor.constraint(
        equalToConstant: Constant.TermsAgreementViewRow.TextLabel.Layout.height
      )
    ])
  }
  
  private func setupChevronButtonConstraints() {
    let length = Constant.TermsAgreementViewRow.ChevronButton.Layout.length
    self.addSubview(self.chevronButton)
    self.chevronButton.usingAutolayout()
    NSLayoutConstraint.activate([
      self.chevronButton.leadingAnchor.constraint(
        equalTo: self.textLabel.trailingAnchor,
        constant: Constant.TermsAgreementViewRow.Layout.commonMargin
      ),
      self.chevronButton.centerYAnchor.constraint(equalTo: centerYAnchor),
      self.chevronButton.widthAnchor.constraint(equalToConstant: length),
      self.chevronButton.heightAnchor.constraint(equalToConstant: length),
      self.chevronButton.trailingAnchor.constraint(equalTo: trailingAnchor)
    ])
  }
  }
  
  // MARK: - NonPrivate Methods
  func configureTitle(with text: String, isBold: Bool = false) {
    var font: UIFont
    if isBold {
      font = UIFont.pretendardHeadSemiBold
    } else {
      font = UIFont.pretendardBodyMedium
    }
    
    self.textLabel.attributedText = text.applyTextAttributes(
      attributes: [
        NSAttributedString.Key.font: font,
        NSAttributedString.Key.foregroundColor:
          UIColor.toDoGardenGreenDark
      ]
    )
  }
