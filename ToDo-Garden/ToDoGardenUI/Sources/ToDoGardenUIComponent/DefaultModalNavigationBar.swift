//
//  CustomNavigationBar.swift
//
//
//  Created by SONG on 11/26/24.
//

import UIKit

import ToDoGardenUIConstant

public protocol DefaultModalNavigationBarDelegate: AnyObject {
  func didTapRightButton()
}

public final class DefaultModalNavigationBar: UIView {
  private let titleLabel: UILabel
  private let rightButton: UIButton
  private let grabberView: UIView
  public weak var delegate: DefaultModalNavigationBarDelegate?
  typealias Constants = Constant.DefaultModalNavigationBar
  
  public init(title: String, rightButtonTitle: String) {
    self.titleLabel = UILabel()
    self.rightButton = UIButton(type: UIButton.ButtonType.system)
    self.grabberView = UIView()
    super.init(frame: CGRect.zero)
    self.setupAppearance()
    self.setupSubviews(title: title, rightButtonTitle: rightButtonTitle)
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupAppearance() {
    self.backgroundColor = UIColor.white
  }
  
  private func setupSubviews(title: String, rightButtonTitle: String) {
    self.setupGrabberView()
    self.setupTitleLabel(with: title)
    self.setupDoneButton(with: rightButtonTitle)
  }
  
  private func setupGrabberView() {
    self.addSubview(self.grabberView)
    self.grabberView.usingAutolayout()
    self.grabberView.layer.cornerRadius = Constants.GrabberView.cornerRadius
    self.grabberView.backgroundColor = UIColor.lightGray
    
    NSLayoutConstraint.activate(
      [
        self.grabberView.topAnchor.constraint(equalTo: self.topAnchor, constant: Constants.GrabberView.topMargin),
        self.grabberView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
        self.grabberView.widthAnchor.constraint(equalToConstant: Constants.GrabberView.width),
        self.grabberView.heightAnchor.constraint(equalToConstant: Constants.GrabberView.height)
      ]
    )
  }
  
  private func setupTitleLabel(with title: String) {
    self.titleLabel.attributedText = title.applyTextAttributes(
      attributes: [
        NSAttributedString.Key.font: UIFont.pretendardHeadBold,
        NSAttributedString.Key.foregroundColor: UIColor.toDoGardenGreenDark
      ]
    )
    self.titleLabel.textAlignment = NSTextAlignment.center
    self.addSubview(self.titleLabel)
    self.titleLabel.usingAutolayout()
    
    NSLayoutConstraint.activate(
      [
        self.titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
        self.titleLabel.topAnchor.constraint(
          equalTo: self.topAnchor,
          constant: Constants.TitleLabel.topMargin
        )
      ]
    )
  }
  
  private func setupDoneButton(with rightButtonTitle: String) {
    let buttonTitle = rightButtonTitle.applyTextAttributes(
      attributes: [
        NSAttributedString.Key.font: UIFont.pretendardBodyRegular,
        NSAttributedString.Key.foregroundColor: UIColor.toDoGardenGreenDark
      ]
    )
    self.rightButton.setAttributedTitle(buttonTitle, for: UIControl.State.normal)
    self.rightButton.addAction(
      UIAction { [weak self] _ in self?.doneButtonTapped() },
      for: UIControl.Event.touchUpInside
    )
    self.addSubview(self.rightButton)
    self.rightButton.usingAutolayout()
    
    NSLayoutConstraint.activate(
      [
        self.rightButton.trailingAnchor.constraint(
          equalTo: self.trailingAnchor,
          constant: Constants.RightButton.trailing
        ),
        self.rightButton.centerYAnchor.constraint(equalTo: self.titleLabel.centerYAnchor)
      ]
    )
  }
  
  private func doneButtonTapped() {
    self.delegate?.didTapRightButton()
  }
}
