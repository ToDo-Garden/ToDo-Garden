//
//  LongestRecordStackView.swift
//
//
//  Created by SONG on 11/18/24.
//

import UIKit

import ToDoGardenUIComponent

final class LongestRecordStackView: UIStackView {
  private let leftView: LongestRecordView
  private let rightView: LongestRecordView
  private let bubbleLabel: BubbleLabel
  
  private typealias Constants = Constant.LongestRecordStackView
  
  init() {
    self.leftView = LongestRecordView(
      style: LongestRecordView.Configuration.pomo,
      title: Constants.StringLiteral.leftViewTitle,
      groupName: "",
      recordCount: Int.zero,
      date: [""]
    )
    self.rightView = LongestRecordView(
      style: LongestRecordView.Configuration.dateRange,
      title: Constants.StringLiteral.rightViewTitle,
      groupName: nil,
      recordCount: Int.zero,
      date: ["", ""]
    )
    
    self.bubbleLabel = BubbleLabel(
      tailPosition: BubbleLabel.TailPosition.left,
      iconImage: UIImage.leafImage,
      text: Constants.StringLiteral.bubbleLabelTitle
    )
    super.init(frame: CGRect.zero)
    self.setupAppearance()
    self.setupShimmerable()
    self.setupBubbleLabel()
    self.setupButtonAction()
  }
  
  @available(*, unavailable)
  required init(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupAppearance() {
    self.axis = NSLayoutConstraint.Axis.horizontal
    self.distribution = UIStackView.Distribution.fillEqually
    self.spacing = Constants.Layout.spacing
    self.alignment = UIStackView.Alignment.fill
    self.addArrangedSubview(self.leftView)
    self.addArrangedSubview(self.rightView)
  }
  
  private func setupShimmerable() {
    self.isShimmering = true
    self.leftView.isShimmering = true
    self.rightView.isShimmering = true
  }
  
  private func setupBubbleLabel() {
    guard let infoButton = self.leftView.informationButton else {
      return
    }
    
    self.addSubview(self.bubbleLabel)
    self.bubbleLabel.usingAutolayout()
    self.bubbleLabel.alpha = CGFloat.zero
    self.bubbleLabel.isHidden = true
    self.bubbleLabel.delegate = self
    
    NSLayoutConstraint.activate(
      [
        self.bubbleLabel.topAnchor.constraint(
          equalTo: infoButton.bottomAnchor,
          constant: Constants.Layout.topMargin
        ),
        self.bubbleLabel.leadingAnchor.constraint(
          equalTo: infoButton.leadingAnchor,
          constant: Constants.Layout.leading
        )
      ]
    )
  }
  
  private func setupButtonAction() {
    self.leftView.informationButton?.addAction(
      UIAction { [weak self] _ in
        self?.didInfoButtonTap()
      },
      for: UIControl.Event.touchUpInside)
  }
  
  private func didInfoButtonTap() {
    if bubbleLabel.isHidden {
      self.showBubbleLabel()
    } else {
      self.hideBubbleLabel()
    }
  }
  
  private func showBubbleLabel() {
    self.bubbleLabel.isHidden = false
    UIView.animate(withDuration: Constants.Animation.duration) {
      self.bubbleLabel.alpha = 1
    }
  }
  
  private func hideBubbleLabel() {
    UIView.animate(
      withDuration: Constants.Animation.duration,
      animations: {
        self.bubbleLabel.alpha = 0
      },
      completion: { _ in
        self.bubbleLabel.isHidden = true
      }
    )
  }
  
  func updateLeftView(groupName: String, recordCount: Int, dateRange: [String]) {
    self.leftView.update(groupName: groupName, recordCount: recordCount, dateRange: dateRange)
  }
  
  func updateRightView(groupName: String? = nil, recordCount: Int, dateRange: [String]) {
    self.rightView.update(groupName: groupName, recordCount: recordCount, dateRange: dateRange)
  }
}

extension LongestRecordStackView: BubbleLabelDelegate {
  func didTap() {
    self.hideBubbleLabel()
  }
}
