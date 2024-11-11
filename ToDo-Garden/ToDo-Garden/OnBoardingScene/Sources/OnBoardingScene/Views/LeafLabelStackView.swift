//
//  LeafLabelStackView.swift
//
//
//  Created by SONG on 11/10/24.
//

import UIKit

import ToDoGardenUIComponent

final class LeafLabelStackView: UIStackView {
  init() {
    super.init(frame: CGRect.zero)
    self.axis = NSLayoutConstraint.Axis.vertical
    self.spacing = Constant.Layout.space
    self.alignment = UIStackView.Alignment.leading
    self.setupViews()
  }
  
  @available(*, unavailable)
  required init(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupViews() {
    let titles = [
      Constant.StringLiteral.firstLineTitle,
      Constant.StringLiteral.secondLineTitle,
      Constant.StringLiteral.thirdLineTitle
    ]
    
    let descriptions = [
      Constant.StringLiteral.firstLineDescription,
      Constant.StringLiteral.secondLineDescription,
      Constant.StringLiteral.thirdLineDescription
    ]
    
    for (index, title) in titles.enumerated() {
      let leafLabel = self.buildLeafLabel(
        titleText: title,
        descriptionText: descriptions[index]
      )
      self.addArrangedSubview(leafLabel)
    }
    
    self.sizeToFit()
  }
  
  // TODO: LeafLabel이 머지되면 사라질 메서드 입니다. LeafLabel의 생성자로 대체될 예정
  private func buildLeafLabel(titleText: String, descriptionText: String) -> UILabel {
    let label = UILabel()
    label.text = "\(titleText)\n\(descriptionText)"
    return label
  }
}
