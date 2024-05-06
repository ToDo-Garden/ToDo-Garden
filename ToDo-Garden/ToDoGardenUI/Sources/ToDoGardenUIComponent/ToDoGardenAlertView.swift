//
//  ToDoGardenAlertView.swift
//
//
//  Created by SONG on 5/4/24.
//

import UIKit

import ToDoGardenUIConstant

final public class ToDoGardenAlertView: UIView {
  var delegate: ToDoGardenAlertViewDelegate?
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
    self.backgroundColor = UIColor.toDoGardenWhite
    self.layer.cornerRadius = self.configuration.contents.backPlane.cornerRadius
    self.buildTitleLabel()
    self.buildDescription()
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
    descriptionView.usingAutolayout()
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
    for (index, item) in configuration.contents.buttons.enumerated() {
      let button = UIButton()
      button.backgroundColor = UIColor.clear
      let textColor = item.isRed ? UIColor.toDoGardenEditButtonRed: UIColor.toDoGardenGreenDark
      let attributedTitle = NSAttributedString(
        string: item.text,
        attributes: [
          NSAttributedString.Key.font: UIFont.pretendardDetailRegular,
          NSAttributedString.Key.foregroundColor: textColor
        ]
      )
      button.setAttributedTitle(attributedTitle, for: UIControl.State.normal)
      self.addButtonTouchActions(at: button, index: index)
      buttons.append(button)
    }
    return buttons
  }
  
  private func addButtonTouchActions(at button: UIButton, index: Int) {
    let touchedAlpha = Constant.ToDoGardenAlertView.Alpha.touchedAlpha
    let normalAlpha = Constant.ToDoGardenAlertView.Alpha.normalAlpha
    button.addAction(
      UIAction(handler: { [weak button] _ in button?.alpha = touchedAlpha }),
      for: UIControl.Event.touchDown
    )
    button.addAction(
      UIAction(handler: { [weak button] _ in button?.alpha = normalAlpha }),
      for: UIControl.Event.touchUpInside
    )
    button.addAction(
      UIAction(handler: { [weak self] _ in self?.buttonTouched(at: index) }),
      for: UIControl.Event.touchUpInside
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
  
  private func addStackedContents(with buttons: [UIButton], at stackView: UIStackView) {
    let one = self.configuration.contents.stackView.dividerThickness
    
    for (index, item) in buttons.enumerated() {
      self.setupItemsLayout(with: item, in: stackView, count: buttons.count)
      if index < buttons.count - Int(one) {
        let divider = self.generateLine()
        self.setupDivierLayout(with: divider, at: stackView, width: one)
      }
    }
  }
  
  private func setupItemsLayout(
    with item: UIButton,
    in stackView: UIStackView,
    count: Int
  ) {
    item.usingAutolayout()
    stackView.addArrangedSubview(item)
    
    if self.configuration.contents.stackView.isHorizontal {
      NSLayoutConstraint.activate(
        [
          item.widthAnchor.constraint(equalToConstant: self.configuration.contents.backPlane.width / CGFloat(count)),
          item.topAnchor.constraint(equalTo: stackView.topAnchor),
          item.bottomAnchor.constraint(equalTo: stackView.bottomAnchor)
        ]
      )
    } else {
      NSLayoutConstraint.activate(
        [
          item.widthAnchor.constraint(equalToConstant: self.configuration.contents.backPlane.width),
          item.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
          item.trailingAnchor.constraint(equalTo: stackView.trailingAnchor)
        ]
      )
    }
  }
  
  private func setupDivierLayout(
    with divider: UIView,
    at stackView: UIStackView,
    width: CGFloat
  ) {
    divider.usingAutolayout()
    stackView.addArrangedSubview(divider)
    
    if self.configuration.contents.stackView.isHorizontal {
      NSLayoutConstraint.activate(
        [
          divider.widthAnchor.constraint(equalToConstant: width),
          divider.topAnchor.constraint(equalTo: stackView.topAnchor),
          divider.bottomAnchor.constraint(equalTo: stackView.bottomAnchor)
        ]
      )
    } else {
      NSLayoutConstraint.activate(
        [
          divider.heightAnchor.constraint(equalToConstant: width),
          divider.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
          divider.trailingAnchor.constraint(equalTo: stackView.trailingAnchor)
        ]
      )
    }
  }
  
  private func addHorizontalTopLine(on stackView: UIStackView) {
    let lineView = self.generateLine()
    let thickness = self.configuration.contents.stackView.dividerThickness
    lineView.backgroundColor = UIColor.toDoGardenGreenGray
    lineView.usingAutolayout()
    stackView.addSubview(lineView)
    NSLayoutConstraint.activate([
      lineView.heightAnchor.constraint(equalToConstant: thickness),
      lineView.topAnchor.constraint(equalTo: stackView.topAnchor),
      lineView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
      lineView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor)
    ])
  }
  
  private func generateLine() -> UIView {
    let lineView = UIView()
    lineView.backgroundColor = UIColor.toDoGardenGreenGray
    return lineView
  }
  
  private func buttonTouched(at index: Int) {
    switch self.configuration.contents.buttons[index].buttonActionType {
    case .cancel:
      self.delegate?.didTapCancel()
    case .keepConcentration:
      self.delegate?.didTapKeepConcentration()
    case .goHome:
      self.delegate?.didTapGoHome()
    case .delete:
      self.delegate?.didTapDelete()
    case .unsubscribe:
      self.delegate?.didTapUnsubscribe()
    case .logout:
      self.delegate?.didTapLogout()
    case .stopConcentration:
      self.delegate?.didTapStopConcentration()
    }
  }
}

extension ToDoGardenAlertView {
  public struct Configuration {
    let contents: Constant.ToDoGardenAlertView.Content.ViewState
    
    public init(contents: Constant.ToDoGardenAlertView.Content.ViewState) {
      self.contents = contents
    }
  }
}

extension ToDoGardenAlertView.Configuration {
  public static let fullyCharged: Self = ToDoGardenAlertView.Configuration.init(
    contents: Constant.ToDoGardenAlertView.Content.fullyCharged.viewState
  )
  
  public static let welldone: Self = ToDoGardenAlertView.Configuration.init(
    contents: Constant.ToDoGardenAlertView.Content.welldone.viewState
  )
  
  public static let askToStop: Self = ToDoGardenAlertView.Configuration.init(
    contents: Constant.ToDoGardenAlertView.Content.askToStop.viewState
  )
  
  public static let askToLogout: Self = ToDoGardenAlertView.Configuration.init(
    contents: Constant.ToDoGardenAlertView.Content.askToLogout.viewState
  )
  
  public static let askToUnsubscribe: Self = ToDoGardenAlertView.Configuration.init(
    contents: Constant.ToDoGardenAlertView.Content.askToUnsubscribe.viewState
  )
  
  public static let askToDeleteGroup: Self = ToDoGardenAlertView.Configuration.init(
    contents: Constant.ToDoGardenAlertView.Content.askToDeleteGroup.viewState
  )
  
  public static let askToDeleteToDo: Self = ToDoGardenAlertView.Configuration.init(
    contents: Constant.ToDoGardenAlertView.Content.askToDeleteToDo.viewState
  )
  
  public static let askToStopResting: Self = ToDoGardenAlertView.Configuration.init(
    contents: Constant.ToDoGardenAlertView.Content.askToStopResting.viewState
  )
}
