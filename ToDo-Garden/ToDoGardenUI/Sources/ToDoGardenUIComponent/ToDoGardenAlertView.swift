//
//  ToDoGardenAlertView.swift
//
//
//  Created by SONG on 5/4/24.
//

import UIKit

import ToDoGardenUIConstant

final public class ToDoGardenAlertView: UIView {
  private var configuration: Configuration
  
  init(configuration: Configuration) {
    self.configuration = configuration
    super.init(frame: CGRect.zero)
    self.build()
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  public override var intrinsicContentSize: CGSize {
    return CGSize(
      width: self.configuration.contents.backPlane.width,
      height: self.configuration.contents.backPlane.height
    )
  }
  
  private func build() {
    // MARK: - BackgroundColor
    self.backgroundColor = UIColor.toDoGardenWhite
    
    // MARK: - CornerRadius
    self.layer.cornerRadius = self.configuration.contents.backPlane.cornerRadius
    
    // MARK: - Title
    self.buildTitleLabel()
    
    // MARK: - Description
    self.buildDescription()
    
    // MARK: - StackView
    self.buildStackView()
  }
}

extension ToDoGardenAlertView {
  private func buildTitleLabel() {
    let label = UILabel()
    label.text = self.configuration.contents.title.text
    label.font = UIFont.pretendardHeadBold
    label.textColor = UIColor.toDoGardenGreenDark
    label.usingAutolayout()
    self.addSubview(label)
    NSLayoutConstraint.activate(
      [
        label.centerXAnchor.constraint(equalTo: self.centerXAnchor),
        label.topAnchor.constraint(equalTo: self.topAnchor, constant: self.configuration.contents.title.topMargin)
      ]
    )
  }
  
  private func buildDescription() {
    let descriptionView = UILabel()
    descriptionView.numberOfLines = self.configuration.contents.description.numberOfLines
    descriptionView.text = self.configuration.contents.description.text
    descriptionView.font = UIFont.pretendardDetailRegular
    descriptionView.textColor = UIColor.toDoGardenGreenDark
    descriptionView.textAlignment = NSTextAlignment.center
    
    descriptionView.translatesAutoresizingMaskIntoConstraints = false
    self.addSubview(descriptionView)
    NSLayoutConstraint.activate(
      [
        descriptionView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
        descriptionView.topAnchor.constraint(
          equalTo: self.topAnchor,
          constant: self.configuration.contents.description.topMargin
        )
      ]
    )
  }
  
  private func buildStackView() {
    let bottomStackView = UIStackView()
    let buttons = self.buildButtons()
    self.addStackedContents(with: buttons, at: bottomStackView)
    self.configureStackViewLayout(at: bottomStackView, buttonsCount: buttons.count)
    self.addHorizontalTopLine(on: bottomStackView)
  }
  
  private func buildButtons() -> [UIButton] {
    var buttons: [UIButton] = []
    
    for item in configuration.contents.buttons {
      let button = UIButton()
      button.backgroundColor = UIColor.clear
      let textColor = item.isRed ? UIColor.toDoGardenRed: UIColor.toDoGardenGreenDark
      let attributedTitle = NSAttributedString(
        string: item.text,
        attributes: [
          .font: UIFont.pretendardDetailRegular,
          .foregroundColor: textColor
        ]
      )
      button.setAttributedTitle(attributedTitle, for: UIControl.State.normal)
      self.addButtonTouchActions(at: button)
      buttons.append(button)
    }
    return buttons
  }
  
  private func addButtonTouchActions(at button: UIButton) {
    let touchedAlpha = Constant.ToDoGardenAlertView.Alpha.touchedAlpha
    let normalAlpha = Constant.ToDoGardenAlertView.Alpha.normalAlpha
    button.addAction(
      UIAction(handler: { [weak button] _ in button?.alpha = touchedAlpha }),
      for: .touchDown
    )
    button.addAction(
      UIAction(handler: { [weak button] _ in button?.alpha = normalAlpha }),
      for: .touchUpInside
    )
  }
  
  private func configureStackViewLayout(at stackView: UIStackView, buttonsCount: Int) {
    if self.configuration.contents.stackView.isHorizontal {
      stackView.axis = NSLayoutConstraint.Axis.horizontal
    } else {
      stackView.axis = NSLayoutConstraint.Axis.vertical
    }
    stackView.distribution = UIStackView.Distribution.fillProportionally
    stackView.alignment = UIStackView.Alignment.fill
    stackView.usingAutolayout()
    self.addSubview(stackView)
    NSLayoutConstraint.activate(
      [
        stackView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
        stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
        stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
      ]
    )
    let height = self.configuration.contents.stackView.height
    if self.configuration.contents.stackView.isHorizontal {
      stackView.heightAnchor.constraint(equalToConstant: height).isActive = true
    } else {
      let buttonCount = CGFloat(buttonsCount)
      stackView.heightAnchor.constraint(equalToConstant: height * buttonCount).isActive = true
    }
  }
  }
}

extension ToDoGardenAlertView {
  public struct Configuration {
    let contents: Constant.ToDoGardenAlertView.Content.ViewState
    
    public init(
      contents: Constant.ToDoGardenAlertView.Content.ViewState
    ) {
      self.contents = contents
    }
  }
}
