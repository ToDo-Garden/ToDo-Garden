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
    let titlesAndDescriptions = [
      (Constant.StringLiteral.firstLineTitle, Constant.StringLiteral.firstLineDescription),
      (Constant.StringLiteral.secondLineTitle, Constant.StringLiteral.secondLineDescription),
      (Constant.StringLiteral.thirdLineTitle, Constant.StringLiteral.thirdLineDescription)
    ]
    
    for (title, description) in titlesAndDescriptions {
      let leafLabel = LeafLabel(titleText: title, descriptionText: description)
      self.addArrangedSubview(leafLabel)
    }
    
    self.sizeToFit()
  }
}
