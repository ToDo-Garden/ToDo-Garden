//
//  DateButtonSet.swift
//
//
//  Created by SONG on 5/28/24.
//

import UIKit

import FoundationExtension
import ToDoGardenUIConstant

public final class DateButtonSet: UIControl {
  private let startDateButton: UIButton
  private let startLabelButton: UIButton
  private let endDateButton: UIButton
  private let endLabelButton: UIButton
  private let stackView: UIStackView
  
  private var _isSelected: Bool
  
  public override var isSelected: Bool {
    get {
      return self._isSelected
    }
    set {
      self._isSelected = newValue
      self.updateButtonSelectionStates()
    }
  }
  
  init() {
    self.startDateButton = UIButton()
    self.startLabelButton = UIButton()
    self.endDateButton = UIButton()
    self.endLabelButton = UIButton()
    self._isSelected = false
    
    super.init(frame: CGRect.zero)
    self.stackView.axis = NSLayoutConstraint.Axis.vertical
    self.setupButtons()
  }
  
  @available(*, unavailable)
  required init(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override public var intrinsicContentSize: CGSize {
    return CGSize(width: 140, height: 52)
  }
  
  private func setupButtons() {
    self.setupButtonStyle()
    self.setupButtonInnerStackView(labelButton: self.startLabelButton, dateButton: self.startDateButton)
    self.setupButtonInnerStackView(labelButton: self.endLabelButton, dateButton: self.endDateButton)
    self.setupButtonActions()
    self.buttonsLayout()
    self.setupStackView()
  }
  
  private func setupButtonStyle() {
    let contentsInsets = Constant.LightRoundRectButton.Layout.contentsInsetsSecondary
    let buttonTitle = Constant.LightRoundRectButton.StringLiteral.self
    self.startDateButton.applyLightRoundRectButtonStyle(title: "")
    self.startDateButton.configuration?.contentInsets = contentsInsets
    self.startLabelButton.applyLightRoundRectButtonStyle(title: buttonTitle.start)
    
    self.endDateButton.applyLightRoundRectButtonStyle(title: "")
    self.endDateButton.configuration?.contentInsets = contentsInsets
    self.endLabelButton.applyLightRoundRectButtonStyle(title: buttonTitle.end)
  }
  
  private func setupButtonInnerStackView(labelButton: UIButton, dateButton: UIButton) {
    let margin = Constant.RepeatOtherDaysView.Layout.DateButtonSet.margin
    let innerStackView = UIStackView()
    innerStackView.axis = NSLayoutConstraint.Axis.horizontal
    innerStackView.distribution = UIStackView.Distribution.fillProportionally
    innerStackView.addArrangedSubview(labelButton)
    innerStackView.addSpacing(margin)
    innerStackView.addArrangedSubview(dateButton)
    
    self.stackView.addArrangedSubview(innerStackView)
    self.stackView.addSpacing(margin)
  }
  
  private func setupButtonActions() {
    let buttons = [
      self.startDateButton,
      self.startLabelButton,
      self.endDateButton,
      self.endLabelButton
    ]
    buttons.forEach { button in
      button.addAction(UIAction { [weak self] _ in
        self?.buttonTapped(button)
      }, for: UIControl.Event.touchUpInside)
    }
  }
  
  private func buttonsLayout() {
    self.startDateButton.usingAutolayout()
    self.endDateButton.usingAutolayout()
    let buttonWidth = Constant.RepeatOtherDaysView.Layout.DateButtonSet.buttonWidth
    NSLayoutConstraint.activate(
      [
        self.startDateButton.widthAnchor.constraint(equalToConstant: buttonWidth),
        self.endDateButton.widthAnchor.constraint(equalToConstant: buttonWidth)
      ]
    )
  }
  
  private func setupStackView() {
    self.stackView.usingAutolayout()
    self.addSubview(self.stackView)

    self.stackView.axis = .vertical
    self.stackView.distribution = .fillProportionally
    NSLayoutConstraint.activate(
      [
        self.stackView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
        self.stackView.centerYAnchor.constraint(equalTo: self.centerYAnchor)
      ]
    )
  }
}

extension DateButtonSet {
  public func updateStartDateButton(title: String) {
    let attributedString = attributedButtonTitle(with: title)
    self.startDateButton.setAttributedTitle(attributedString, for: .normal)
  }
  
  public func updateEndDateButton(title: String) {
    let attributedString = attributedButtonTitle(with: title)
    self.endDateButton.setAttributedTitle(attributedString, for: .normal)
  }
  
  private func updateButtonSelectionStates() {
    startDateButton.isSelected = _isSelected
    startLabelButton.isSelected = _isSelected
    endDateButton.isSelected = _isSelected
    endLabelButton.isSelected = _isSelected
  }
  
  private func buttonTapped(_ sender: UIButton) {
    if sender.isSelected {
      self.isSelected = true
    } else {
      let isAllSelected = 
      self.startDateButton.isSelected &&
      self.startLabelButton.isSelected &&
      self.endDateButton.isSelected &&
      self.endLabelButton.isSelected
      
      if !isAllSelected {
        self.isSelected = false
      }
    }
    self.sendActions(for: .touchUpInside)
  }
  
  private func attributedButtonTitle(with title: String) -> NSAttributedString {
    let attributedString = title.applyTextAttributes(
      attributes: [
        NSAttributedString.Key.font: UIFont.pretendardBodySemiBold
      ]
    )
    return attributedString
  }
}
