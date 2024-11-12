//
//  LongestRecordView.swift
//
//
//  Created by SONG on 11/12/24.
//

import UIKit

import TDFoundationExtension
import ToDoGardenUIResource

public final class LongestRecordView: UIView {
  private let titleLabel: UILabel
  private let labelStackView: UIStackView
  
  public var informationButton: UIButton?
  
  public enum Configuration {
    case pomo
    case dateRange
  }
  
  public init(
    style: LongestRecordView.Configuration,
    title: String,
    groupName: String? = nil,
    recordCount: Int,
    date: [Date]
  ) {
    self.titleLabel = UILabel()
    self.labelStackView = UIStackView(frame: CGRect.zero)
    super.init(frame: CGRect.zero)
    self.backgroundColor = UIColor.white
    self.layer.cornerRadius = 10.0
    self.layer.borderWidth = 1.0
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
    NSLayoutConstraint.activate(
      [
        self.titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 10.0),
        self.titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 12.0)
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
    NSLayoutConstraint.activate(
      [
        button.leadingAnchor.constraint(equalTo: self.titleLabel.trailingAnchor, constant: 3.0),
        button.centerYAnchor.constraint(equalTo: self.titleLabel.centerYAnchor),
        button.widthAnchor.constraint(equalToConstant: 12.0),
        button.heightAnchor.constraint(equalToConstant: 12.0)
      ]
    )
  }
  
  private func setupLabelStackView(
    style: LongestRecordView.Configuration,
    groupName: String?,
    recordCount: Int,
    date: [Date]
  ) {
    self.labelStackView.axis = NSLayoutConstraint.Axis.vertical
    self.labelStackView.alignment = UIStackView.Alignment.trailing
    self.labelStackView.spacing = 1.0
    
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
    NSLayoutConstraint.activate(
      [
        self.labelStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -12.0),
        self.labelStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -12.0)
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
    NSLayoutConstraint.activate(
      [
        imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15.0),
        imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -21.0),
        imageView.widthAnchor.constraint(equalToConstant: 30.0),
        imageView.heightAnchor.constraint(equalToConstant: 38.0)
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
        NSAttributedString.Key.font: UIFont.pretendardDetailLight,
        NSAttributedString.Key.foregroundColor: UIColor.toDoGardenGreenGray
      ]
    )
    
    return label
  }
  
  private func buildRecordLabel(style: LongestRecordView.Configuration, with recordCount: Int) -> UILabel {
    var text: String
    
    switch style {
    case .pomo:
      text = "\(recordCount)뽀모"
    case .dateRange:
      text = "\(recordCount)일"
    }
    
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
        NSAttributedString.Key.font: UIFont.pretendardDetailLight,
        NSAttributedString.Key.foregroundColor: UIColor.toDoGardenGray3
      ]
    )
    
    return label
  }
}
