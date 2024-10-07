//
//  AnimatedMultiLinesTitleView.swift
//
//
//  Created by SONG on 10/6/24.
//

import UIKit

import ToDoGardenUIConstant
import ToDoGardenUIResource

final class AnimatedMultiLinesTitleView: UIStackView {
  private let mainTitleLabelFirst: UILabel
  private let mainTitleLabelSecond: UILabel
  private let subTitleLabel: UILabel
  
  private let firstLineText: String
  private let secondLineText: String
  private let thirdLineText: String
  
  init(
    firstLineText: String,
    secondLineText: String,
    thirdLineText: String
  ) {
    self.mainTitleLabelFirst = UILabel()
    self.mainTitleLabelSecond = UILabel()
    self.subTitleLabel = UILabel()
    self.firstLineText = firstLineText
    self.secondLineText = secondLineText
    self.thirdLineText = thirdLineText
    super.init(frame: CGRect.zero)
    self.setupStackView()
    self.setupTitles()
  }
  
  @available(*, unavailable)
  required init(coder: NSCoder) {
    fatalError()
  }
extension AnimatedMultiLinesTitleView {
  private func setupStackView() {
    self.axis = NSLayoutConstraint.Axis.vertical
    self.spacing = 4.0
    self.alignment = UIStackView.Alignment.leading
    
    self.addArrangedSubview(self.mainTitleLabelFirst)
    self.addArrangedSubview(self.mainTitleLabelSecond)
    self.addArrangedSubview(self.subTitleLabel)
  }

  private func setupTitles() {
    self.setupMainTitle(text: self.firstLineText, at: self.mainTitleLabelFirst)
    self.setupMainTitle(text: self.secondLineText, at: self.mainTitleLabelSecond)
    self.setupSubTitle(text: self.thirdLineText)
  }
  
  private func setupMainTitle(text: String, at mainTitleLabel: UILabel) {
    mainTitleLabel.numberOfLines = 1
    mainTitleLabel.attributedText = text.applyTextAttributes(attributes: [
      NSAttributedString.Key.font: UIFont.pretendardHeadBold,
      NSAttributedString.Key.foregroundColor: UIColor.toDoGardenGreenDark
    ])
    mainTitleLabel.text = ""
  }
  
  private func setupSubTitle(text: String) {
    self.subTitleLabel.numberOfLines = 1
    self.subTitleLabel.attributedText = text.applyTextAttributes(attributes: [
      NSAttributedString.Key.font: UIFont.pretendardDetailRegular12,
      NSAttributedString.Key.foregroundColor: UIColor.toDoGardenGreenDark
    ])
    self.subTitleLabel.text = ""
  }
}

}
