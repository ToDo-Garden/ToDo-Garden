//
//  MyStatsPeriodicSummaryView.swift
//  
//
//  Created by SONG on 11/18/24.
//

import UIKit

import ToDoGardenUIComponent

final class MyStatsPeriodicSummaryView: UIView {
  private let titleLabel: UILabel
  private let segmentedControl: PeriodSegmentedControl
  private let summaryView: MyStatsSummaryView
  
  private typealias Constants = Constant.MyStatsPeriodicSummaryView
  
  init() {
    self.titleLabel = UILabel()
    self.segmentedControl = PeriodSegmentedControl()
    self.summaryView = MyStatsSummaryView(
      leftTitle: Constants.StringLiteral.leftViewTitle,
      leftDescription: Constants.StringLiteral.leftViewDesc,
      rightTitle: Constants.StringLiteral.rightViewTitle,
      rightDescription: Constants.StringLiteral.rightViewDesc
    )
    super.init(frame: CGRect.zero)
    self.setupView()
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  public func updateSummaryView(
    leftTitle: String? = nil,
    leftDescription: String,
    rightTitle: String? = nil,
    rightDescription: String
  ) {
    self.summaryView.updateLeftView(title: leftTitle, description: leftDescription)
    self.summaryView.updateRightView(title: rightTitle, description: rightDescription)
  }
  
  private func setupView() {
    self.setupTitleLabel()
    self.setupSegmentedControl()
    self.setupSummaryView()
  }
  
  private func setupTitleLabel() {
    let title = Constants.StringLiteral.headerTitle
    self.titleLabel.attributedText = title.applyTextAttributes(
      attributes: [
        NSAttributedString.Key.font: UIFont.pretendardHeadBold,
        NSAttributedString.Key.foregroundColor: UIColor.toDoGardenGreenDark
      ]
    )
    
    self.addSubview(self.titleLabel)
    self.titleLabel.usingAutolayout()
    NSLayoutConstraint.activate(
      [
        self.titleLabel.topAnchor.constraint(equalTo: self.topAnchor),
        self.titleLabel.leadingAnchor.constraint(
          equalTo: self.leadingAnchor,
          constant: Constants.Layout.horizontalMargin
        )
      ]
    )
  }
  
  private func setupSegmentedControl() {
    self.addSubview(self.segmentedControl)
    self.segmentedControl.usingAutolayout()
    NSLayoutConstraint.activate(
      [
        self.segmentedControl.centerYAnchor.constraint(equalTo: self.titleLabel.centerYAnchor),
        self.segmentedControl.trailingAnchor.constraint(
          equalTo: self.trailingAnchor,
          constant: -Constants.Layout.horizontalMargin
        )
      ]
    )
  }
  
  private func setupSummaryView() {
    self.addSubview(self.summaryView)
    self.summaryView.usingAutolayout()
    NSLayoutConstraint.activate(
      [
        self.summaryView.topAnchor.constraint(
          equalTo: self.titleLabel.bottomAnchor,
          constant: Constants.Layout.topMargin
        ),
        self.summaryView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
        self.summaryView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
        self.summaryView.heightAnchor.constraint(equalToConstant: Constants.Layout.summaryViewHeight)
      ]
    )
  }
}
