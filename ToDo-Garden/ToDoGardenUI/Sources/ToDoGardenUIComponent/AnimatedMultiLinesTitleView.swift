//
//  DynamicInfoInputView.swift
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
  }
  
  @available(*, unavailable)
  required init(coder: NSCoder) {
    fatalError()
  }
}
