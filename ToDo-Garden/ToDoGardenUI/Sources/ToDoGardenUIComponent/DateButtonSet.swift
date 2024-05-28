//
//  DateButtonSet.swift
//
//
//  Created by SONG on 5/28/24.
//

import UIKit

import ToDoGardenUIConstant

public class DateButtonSet: UIStackView {
  public var delegate: DateButtonSetDelegate?
  private let startDateButton: UIButton
  private let startLabelButton: UIButton
  private let endDateButton: UIButton
  private let endLabelButton: UIButton
  
  private var _isSelected: Bool
  
  var isSelected: Bool {
    get {
      return self._isSelected
    }
    set {
      self._isSelected = newValue
      self.updateButtonSelectionStates()
      self.delegate?.dateButtonTapped(isSelected: _isSelected)
    }
  }
  
  init() {
    self.delegate = nil
    self.startDateButton = UIButton()
    self.startLabelButton = UIButton()
    self.endDateButton = UIButton()
    self.endLabelButton = UIButton()
    self._isSelected = false
    
    super.init(frame: CGRect.zero)
    self.axis = NSLayoutConstraint.Axis.vertical
    self.setupButtons()
  }
  
  @available(*, unavailable)
  required init(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupButtons() {
    self.setupButtonStyle()
    self.setupButtonInnerStackView(labelButton: self.startLabelButton, dateButton: self.startDateButton)
    self.setupButtonInnerStackView(labelButton: self.endLabelButton, dateButton: self.endDateButton)
    self.setupButtonActions()
    self.buttonsLayout()
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
    
    self.addArrangedSubview(innerStackView)
    self.addSpacing(margin)
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

  }
}

extension DateButtonSet {
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
  }
}

public protocol DateButtonSetDelegate: AnyObject {
  func dateButtonTapped(isSelected: Bool)
}
