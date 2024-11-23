//
//  MyStatsSummaryView.swift
//
//
//  Created by SONG on 11/17/24.
//

import UIKit

import ToDoGardenUIConstant
import ToDoGardenUIResource

public final class MyStatsSummaryView: UIView {
  private let verticalLine: UIView
  private let leftView: TitleDescriptionView
  private let rightView: TitleDescriptionView
  
  public init(
    leftTitle: String,
    leftDescription: String,
    rightTitle: String,
    rightDescription: String
  ) {
    self.verticalLine = UIView()
    self.leftView = TitleDescriptionView()
    self.rightView = TitleDescriptionView()
    super.init(frame: CGRect.zero)
    self.setupAppearance()
    self.setupView(
      leftTitle: leftTitle,
      leftDescription: leftDescription,
      rightTitle: rightTitle,
      rightDescription: rightDescription
    )
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  public func updateLeftView(title: String? = nil, description: String) {
    if let title = title {
      self.leftView.updateTitleLabel(text: title)
    }
    
    self.leftView.updateDescriptionLabel(text: description)
  }
  
  public func updateRightView(title: String? = nil, description: String) {
    if let title = title {
      self.rightView.updateTitleLabel(text: title)
    }
    self.rightView.updateDescriptionLabel(text: description)
    
  }
  
  private func setupAppearance() {
    self.backgroundColor = UIColor.white
    self.layer.cornerRadius = Constant.MyStatsSummaryView.Layout.cornerRadius
    self.layer.borderColor = UIColor.toDoGardenGreenGray.cgColor
    self.layer.borderWidth = 1
  }
  
  private func setupView(
    leftTitle: String,
    leftDescription: String,
    rightTitle: String,
    rightDescription: String
  ) {
    self.verticalLine.backgroundColor = UIColor.toDoGardenGreenGray
    
    self.updateLeftView(title: leftTitle, description: leftDescription)
    self.updateRightView(title: rightTitle, description: rightDescription)
    
    self.addSubview(self.verticalLine)
    self.addSubview(self.leftView)
    self.addSubview(self.rightView)
    
    self.setupVerticalLineConstraints()
    self.setupLeftViewConstraints()
    self.setupRightViewConstraints()
  }
  
  private func setupVerticalLineConstraints() {
    self.verticalLine.usingAutolayout()
    let constant = Constant.MyStatsSummaryView.Layout.self
    NSLayoutConstraint.activate([
      self.verticalLine.widthAnchor.constraint(equalToConstant: 2),
      self.verticalLine.centerXAnchor.constraint(equalTo: self.centerXAnchor),
      self.verticalLine.topAnchor.constraint(equalTo: self.topAnchor, constant: constant.verticalLineMargin),
      self.verticalLine.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -constant.verticalLineMargin)
    ])
  }
  
  private func setupLeftViewConstraints() {
    self.leftView.usingAutolayout()
    let constant = Constant.MyStatsSummaryView.Layout.self
    NSLayoutConstraint.activate([
      self.leftView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: constant.commonMargin),
      self.leftView.topAnchor.constraint(equalTo: self.topAnchor, constant: constant.commonMargin),
      self.leftView.trailingAnchor.constraint(
        equalTo: self.verticalLine.leadingAnchor,
        constant: -constant.commonMargin
      ),
      self.leftView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -constant.commonMargin)
    ])
  }
  
  private func setupRightViewConstraints() {
    self.rightView.usingAutolayout()
    let constant = Constant.MyStatsSummaryView.Layout.self
    NSLayoutConstraint.activate([
      self.rightView.leadingAnchor.constraint(
        equalTo: self.verticalLine.trailingAnchor,
        constant: constant.commonMargin
      ),
      self.rightView.topAnchor.constraint(equalTo: self.topAnchor, constant: constant.commonMargin),
      self.rightView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -constant.commonMargin),
      self.rightView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -constant.commonMargin)
    ])
  }
}

final class TitleDescriptionView: UIView {
  private let titleLabel: UILabel
  private let descriptionLabel: UILabel
  
  override init(frame: CGRect) {
    self.titleLabel = UILabel()
    self.titleLabel.usingAutolayout()
    
    self.descriptionLabel = UILabel()
    self.descriptionLabel.usingAutolayout()
    
    super.init(frame: frame)
    self.setupView()
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupView() {
    self.addSubview(self.titleLabel)
    self.addSubview(self.descriptionLabel)
    
    self.setupShimmerable()
    
    self.setupTitleLabelConstraints()
    self.setupDescriptionLabelConstraints()
  }
  
  private func setupShimmerable() {
    self.descriptionLabel.layer.cornerRadius = 5.0
    self.isShimmering = true
    self.descriptionLabel.isShimmering = true
  }
  
  private func setupTitleLabelConstraints() {
    let constant = Constant.MyStatsSummaryView.Layout.self
    NSLayoutConstraint.activate([
      self.titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: constant.labelMargin),
      self.titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: constant.labelMargin)
    ])
  }
  
  private func setupDescriptionLabelConstraints() {
    let constant = Constant.MyStatsSummaryView.Layout.self
    NSLayoutConstraint.activate([
      self.descriptionLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -constant.commonMargin),
      self.descriptionLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -constant.labelMargin)
    ])
  }
  
  func updateTitleLabel(text: String) {
    self.titleLabel.attributedText = text.applyTextAttributes(
      attributes: [
        NSAttributedString.Key.font: UIFont.pretendardBodySemiBold,
        NSAttributedString.Key.foregroundColor: UIColor.toDoGardenGreenDark
      ]
    )
  }
  
  func updateDescriptionLabel(text: String) {
    self.descriptionLabel.attributedText = text.applyTextAttributes(
      attributes: [
        NSAttributedString.Key.font: UIFont.pretendardHeadBold,
        NSAttributedString.Key.foregroundColor: UIColor.toDoGardenGreenDark
      ]
    )
  }
}

#if DEBUG
@available(iOS 17.0, *)
#Preview {
  let view = MyStatsSummaryView(
    leftTitle: "평균 집중 시간",
    leftDescription: "3시간 50분",
    rightTitle: "평균 완료 수",
    rightDescription: "3개 목표"
  )
  
  view.usingAutolayout()
  
  NSLayoutConstraint.activate(
    [
      view.widthAnchor.constraint(equalToConstant: 331.0),
      view.heightAnchor.constraint(equalToConstant: 103)
    ]
  )
  return view
}
#endif
