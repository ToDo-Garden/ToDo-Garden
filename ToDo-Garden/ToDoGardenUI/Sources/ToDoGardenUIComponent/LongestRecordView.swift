//
//  LongestRecordView.swift
//
//
//  Created by SONG on 11/12/24.
//

import UIKit

import TDFoundationExtension
import ToDoGardenUIConstant
import ToDoGardenUIResource

public final class LongestRecordView: UIView {
  private let titleLabel: UILabel
  private var groupNameLabel: UILabel?
  private var recordLabel: UILabel
  private var dateLabel: UILabel
  private let style: LongestRecordView.Configuration
  
  public var informationButton: UIButton?
  
  public enum Configuration {
    case pomo
    case dateRange
  }
  
  public init(
    style: LongestRecordView.Configuration,
    title: String,
    groupName: String?,
    recordCount: Int,
    date: [String]
  ) {
    self.style = style
    self.titleLabel = UILabel()
    self.groupNameLabel = UILabel()
    self.recordLabel = UILabel()
    self.dateLabel = UILabel()
    super.init(frame: CGRect.zero)
    self.backgroundColor = UIColor.white
    self.layer.cornerRadius = Constant.LongestRecordView.Layout.cornerRadius
    self.layer.borderWidth = Constant.LongestRecordView.Layout.borderWidth
    self.layer.borderColor = UIColor.toDoGardenGreenGray.cgColor
    self.setupViews(
      title: title,
      groupName: groupName,
      recordCount: recordCount,
      dateRange: date
    )
    self.setupShimmerable()
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  public func update(
    groupName: String?,
    recordCount: Int,
    dateRange: [String]
  ) {
    self.setupGroupNameLabel(with: groupName)
    self.setupRecordLabel(with: recordCount)
    self.setupDateLabel(with: dateRange)
  }
}

extension LongestRecordView {
  private func setupViews(
    title: String,
    groupName: String?,
    recordCount: Int,
    dateRange: [String]
  ) {
    self.setupTitleView(with: title)
    self.setupLeafSymbolImageView()
    self.setupGroupNameLabel(with: groupName)
    self.setupRecordLabel(with: recordCount)
    self.setupDateLabel(with: dateRange)
    self.setupLabelsConstraints()
  }
  
  private func setupTitleView(with title: String) {
    self.titleLabel.attributedText = title.applyTextAttributes(
      attributes: [
        NSAttributedString.Key.font: UIFont.pretendardBodySemiBold,
        NSAttributedString.Key.foregroundColor: UIColor.toDoGardenGreenDark
      ]
    )
    
    self.addSubview(self.titleLabel)
    self.titleLabel.usingAutolayout()
    
    self.setupTitleLabelConstraints()
    self.setupInformationButton()
  }
  
  private func setupTitleLabelConstraints() {
    let constant = Constant.LongestRecordView.TitleLabel.Layout.self
    NSLayoutConstraint.activate(
      [
        self.titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: constant.top),
        self.titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: constant.leading)
      ]
    )
  }
  
  private func setupInformationButton() {
    switch self.style {
    case .pomo:
      self.informationButton = UIButton()
      guard let informationButton = self.informationButton else { return }
      
      informationButton.tintColor = UIColor.toDoGardenGreenDark
      informationButton.usingAutolayout()
      informationButton.setImage(UIImage.informationMark, for: UIControl.State.normal)
      self.addSubview(informationButton)
      self.setupInformationButtonConstraints(informationButton)
      
    case .dateRange:
      return
    }
  }
  
  private func setupInformationButtonConstraints(_ button: UIButton) {
    let constant = Constant.LongestRecordView.InfoButton.Layout.self
    NSLayoutConstraint.activate(
      [
        button.leadingAnchor.constraint(equalTo: self.titleLabel.trailingAnchor, constant: constant.leading),
        button.centerYAnchor.constraint(equalTo: self.titleLabel.centerYAnchor),
        button.widthAnchor.constraint(equalToConstant: constant.length),
        button.heightAnchor.constraint(equalToConstant: constant.length)
      ]
    )
  }
  
  private func setupLabelsConstraints() {
    
    self.addSubview(self.dateLabel)
    self.dateLabel.usingAutolayout()
    self.setupDateLabelConstraints()
    
    self.addSubview(self.recordLabel)
    self.recordLabel.usingAutolayout()
    self.setupRecordLabelConstraints()
    
    if let groupNameLabel = self.groupNameLabel {
      self.addSubview(groupNameLabel)
      groupNameLabel.usingAutolayout()
      self.setupGroupNameLabelConstraints(groupNameLabel)
    }

  }
  
  private func setupGroupNameLabelConstraints(_ label: UILabel) {
    let constant = Constant.LongestRecordView.LabelStackView.Layout.self
    NSLayoutConstraint.activate(
      [
        label.bottomAnchor.constraint(equalTo: self.recordLabel.topAnchor, constant: -1),
        label.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: constant.commonMargin)
      ]
    )
  }
  
  private func setupRecordLabelConstraints() {
    let constant = Constant.LongestRecordView.LabelStackView.Layout.self
    NSLayoutConstraint.activate(
      [
        self.recordLabel.bottomAnchor.constraint(equalTo: self.dateLabel.topAnchor, constant: -1),
        self.recordLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: constant.commonMargin)
      ]
    )
  }
  
  private func setupDateLabelConstraints() {
    let constant = Constant.LongestRecordView.LabelStackView.Layout.self
    NSLayoutConstraint.activate(
      [
        self.dateLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: constant.commonMargin),
        self.dateLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: constant.commonMargin)
      ]
    )
  }
  
  private func setupLeafSymbolImageView() {
    let imageView = UIImageView(image: UIImage.leafSymbolImage)
    imageView.alpha = 0.5
    self.addSubview(imageView)
    imageView.usingAutolayout()
    
    self.setupLeafSymbolImageViewConstraints(imageView)
  }
  
  private func setupLeafSymbolImageViewConstraints(_ imageView: UIImageView) {
    let constant = Constant.LongestRecordView.LeafSymbol.Layout.self
    NSLayoutConstraint.activate(
      [
        imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: constant.leading),
        imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: constant.bottom),
        imageView.widthAnchor.constraint(equalToConstant: constant.width),
        imageView.heightAnchor.constraint(equalToConstant: constant.height)
      ]
    )
  }
}

extension LongestRecordView {
  private func setupGroupNameLabel(with groupName: String?) {
    guard let groupName = groupName else {
      return
    }

    self.groupNameLabel?.attributedText = groupName.applyTextAttributes(
      attributes: [
        NSAttributedString.Key.font: UIFont.pretendardDetailLight10,
        NSAttributedString.Key.foregroundColor: UIColor.toDoGardenGreenGray
      ]
    )
  }
  
  private func setupRecordLabel(with recordCount: Int) {
    var text: String
    var unit: String
    switch self.style {
    case .pomo:
      unit = Constant.LongestRecordView.StringLiteral.pomo
    case .dateRange:
      unit = Constant.LongestRecordView.StringLiteral.day
    }
    text = "\(recordCount)\(unit)"
    
    self.recordLabel.attributedText = text.applyTextAttributes(
      attributes: [
        NSAttributedString.Key.font: UIFont.pretendardHeadBold,
        NSAttributedString.Key.foregroundColor: UIColor.toDoGardenGreenDark
      ]
    )
  }
  
  private func setupDateLabel(with date: [String]) {
    var text: String = ""
    switch self.style {
    case .pomo:
      text = date.first ?? ""
    case .dateRange:
      let startDate = date.first ?? ""
      let endDate = date.last ?? ""
      text = "\(startDate) ~ \(endDate)"
    }

    self.dateLabel.attributedText = text.applyTextAttributes(
      attributes: [
        NSAttributedString.Key.font: UIFont.pretendardDetailLight10,
        NSAttributedString.Key.foregroundColor: UIColor.toDoGardenGray3
      ]
    )
  }
  
  private func setupShimmerable() {
    let labels = [self.groupNameLabel, self.recordLabel, self.dateLabel].compactMap { $0 }
    
    for label in labels {
      label.layer.cornerRadius = 5.0
      label.isShimmering = true
    }
  }
}

@available(iOS 17.0, *)
#Preview {
  let stackView = UIHStackView(
    alignment: UIStackView.Alignment.fill,
    arrangedSubviews: []
  )
  stackView.distribution = .fillEqually
  
  let view1 = LongestRecordView(
    style: .pomo,
    title: "최장 집중 기록",
    groupName: "아아아아아아",
    recordCount: 9,
    date: ["1111.11.11"]
  )
  
  let view2 = LongestRecordView(
    style: .dateRange,
    title: "최장 연속 기록",
    groupName: nil,
    recordCount: 30,
    date: ["9900.99.99", "9999.99.99"]
  )
  
  view1.usingAutolayout()
  view2.usingAutolayout()
  view2.startShimmering()
  
  stackView.addArrangedSubview(view1)
  stackView.addArrangedSubview(view2)
  
  stackView.usingAutolayout()
  NSLayoutConstraint.activate(
    [
      stackView.widthAnchor.constraint(equalToConstant: 332),
      stackView.heightAnchor.constraint(equalToConstant: 125)
    ]
  )
  
  return stackView
}
