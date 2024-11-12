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
  private let labelStackView: UIVStackView
  
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
    date: [Date]
  ) {
    self.titleLabel = UILabel()
    self.labelStackView = UIVStackView(
      alignment: UIStackView.Alignment.trailing,
      spacing: 1.0,
      arrangedSubviews: []
    )
    super.init(frame: CGRect.zero)
    self.backgroundColor = UIColor.white
    self.layer.cornerRadius = Constant.LongestRecordView.Layout.cornerRadius
    self.layer.borderWidth = Constant.LongestRecordView.Layout.borderWidth
    self.layer.borderColor = UIColor.toDoGardenGreenGray.cgColor
    self.setupViews(
      style: style,
      title: title,
      groupName: groupName,
      recordCount: recordCount,
      date: date
    )
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension LongestRecordView {
  private func setupViews(
    style: LongestRecordView.Configuration,
    title: String,
    groupName: String?,
    recordCount: Int,
    date: [Date]
  ) {
    self.setupTitleView(style: style, with: title)
    self.setupLabelStackView(style: style, groupName: groupName, recordCount: recordCount, date: date)
    self.setupLeafSymbolImageView()
  }
  
  private func setupTitleView(style: LongestRecordView.Configuration, with title: String) {
    self.titleLabel.attributedText = title.applyTextAttributes(
      attributes: [
        NSAttributedString.Key.font: UIFont.pretendardBodySemiBold,
        NSAttributedString.Key.foregroundColor: UIColor.toDoGardenGreenDark
      ]
    )
    
    self.addSubview(self.titleLabel)
    self.titleLabel.usingAutolayout()
    
    self.setupTitleLabelConstraints()
    self.setupInformationButton(style: style)
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
  
  private func setupInformationButton(style: LongestRecordView.Configuration) {
    switch style {
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
  
  private func setupLabelStackView(
    style: LongestRecordView.Configuration,
    groupName: String?,
    recordCount: Int,
    date: [Date]
  ) {
    self.addSubview(self.labelStackView)
    self.labelStackView.usingAutolayout()
    
    self.addLabelsToStackView(style: style, groupName: groupName, recordCount: recordCount, date: date)
    self.setupLabelStackViewConstraints()
  }
  
  private func addLabelsToStackView(
    style: LongestRecordView.Configuration,
    groupName: String?,
    recordCount: Int,
    date: [Date]
  ) {
    let groupNameLabel = self.buildGroupNameLabel(with: groupName)
    let recordLabel = self.buildRecordLabel(style: style, with: recordCount)
    let dateLabel = self.buildDateLabel(style: style, with: date)
    
    let labels = [groupNameLabel, recordLabel, dateLabel]
    
    for label in labels {
      guard let label = label else {
        continue
      }
      
      self.labelStackView.addArrangedSubview(label)
    }
  }
  
  private func setupLabelStackViewConstraints() {
    let constant = Constant.LongestRecordView.LabelStackView.Layout.self
    NSLayoutConstraint.activate(
      [
        self.labelStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: constant.commonMargin),
        self.labelStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: constant.commonMargin)
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
  private func buildGroupNameLabel(with groupName: String?) -> UILabel? {
    guard let groupName = groupName else {
      return nil
    }
    
    let label = UILabel(frame: CGRect.zero)
    label.attributedText = groupName.applyTextAttributes(
      attributes: [
        NSAttributedString.Key.font: UIFont.pretendardDetailLight10,
        NSAttributedString.Key.foregroundColor: UIColor.toDoGardenGreenGray
      ]
    )
    
    return label
  }
  
  private func buildRecordLabel(style: LongestRecordView.Configuration, with recordCount: Int) -> UILabel {
    var text: String
    var unit: String
    switch style {
    case .pomo:
      unit = Constant.LongestRecordView.StringLiteral.pomo
    case .dateRange:
      unit = Constant.LongestRecordView.StringLiteral.day
    }
    text = "\(recordCount)\(unit)"
    
    let label = UILabel(frame: CGRect.zero)
    label.attributedText = text.applyTextAttributes(
      attributes: [
        NSAttributedString.Key.font: UIFont.pretendardHeadBold,
        NSAttributedString.Key.foregroundColor: UIColor.toDoGardenGreenDark
      ]
    )
    
    return label
  }
  
  private func buildDateLabel(style: LongestRecordView.Configuration, with date: [Date]) -> UILabel {
    var text: String = ""
    switch style {
    case .pomo:
      text = date.first?.toStringDefaultFormat() ?? ""
    case .dateRange:
      let startDate = date.first?.toStringDefaultFormat() ?? ""
      let endDate = date.last?.toStringDefaultFormat() ?? ""
      text = "\(startDate) ~ \(endDate)"
    }
    
    let label = UILabel(frame: CGRect.zero)
    label.attributedText = text.applyTextAttributes(
      attributes: [
        NSAttributedString.Key.font: UIFont.pretendardDetailLight10,
        NSAttributedString.Key.foregroundColor: UIColor.toDoGardenGray3
      ]
    )
    
    return label
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
    date: [Date.now]
  )
  
  let view2 = LongestRecordView(
    style: .dateRange,
    title: "최장 연속 기록",
    groupName: nil,
    recordCount: 30,
    date: [Date.now, Date.now]
  )
  
  view1.usingAutolayout()
  view2.usingAutolayout()

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
