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
  
  private let constants = Constant.LongestRecordStackView.self
  
  init() {
    self.leftView = LongestRecordView(
      style: LongestRecordView.Configuration.pomo,
      title: self.constants.StringLiteral.leftViewTitle,
      groupName: "",
      recordCount: Int.zero,
      date: [Date.now]
    )
    self.rightView = LongestRecordView(
      style: LongestRecordView.Configuration.dateRange,
      title: self.constants.StringLiteral.rightViewTitle,
      groupName: nil,
      recordCount: Int.zero,
      date: [Date.now, Date.now]
    )
    
    self.bubbleLabel = BubbleLabel(
      tailPosition: BubbleLabel.TailPosition.left,
      iconImage: UIImage.leafImage,
      text: self.constants.StringLiteral.bubbleLabelTitle
    )
    super.init(frame: CGRect.zero)
    self.setupAppearance()
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
    self.spacing = self.constants.Layout.spacing
    self.alignment = UIStackView.Alignment.fill
    self.addArrangedSubview(self.leftView)
    self.addArrangedSubview(self.rightView)
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
          constant: self.constants.Layout.topMargin
        ),
        self.bubbleLabel.leadingAnchor.constraint(
          equalTo: infoButton.leadingAnchor,
          constant: self.constants.Layout.leading
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
    UIView.animate(withDuration: self.constants.Animation.duration) {
      self.bubbleLabel.alpha = 1
    }
  }
  
  private func hideBubbleLabel() {
    UIView.animate(
      withDuration: self.constants.Animation.duration,
      animations: {
        self.bubbleLabel.alpha = 0
      },
      completion: { _ in
        self.bubbleLabel.isHidden = true
      }
    )
  }
  
  func updateLeftView(groupName: String, recordCount: Int, dateRange: [Date]) {
    self.leftView.update(groupName: groupName, recordCount: recordCount, dateRange: dateRange)
  }
  
  func updateRightView(groupName: String? = nil, recordCount: Int, dateRange: [Date]) {
    self.rightView.update(groupName: groupName, recordCount: recordCount, dateRange: dateRange)
  }
}

extension LongestRecordStackView: BubbleLabelDelegate {
  func didTap() {
    self.hideBubbleLabel()
  }
}
