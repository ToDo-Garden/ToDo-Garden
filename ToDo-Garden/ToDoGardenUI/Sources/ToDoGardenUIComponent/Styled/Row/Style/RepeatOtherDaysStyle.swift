//
//  OtherDaysListStyle.swift
//
//
//  Created by SONG on 5/14/24.
//

import UIKit

import ToDoGardenUIConstant

extension Styled.Row {
  func buildRepeatOtherDaysStyle(stack: UIStackView, model: Configuration.RepeatOtherDaysModel, views: [UIView]?) {
    stack.alignment = UIStackView.Alignment.center
    self.buildStack(
      stack: stack,
      edgeInsets: Constant.Styled.Row.ListPrimary.stackEdgeInsets
    )
    let labelConfiguration = GroupNameLabel.Configuration.self
    let label = GroupNameLabel(
      configuration: labelConfiguration.primary(
        labelConfiguration.PrimaryModel.repeatOtherDaysModel
      )
    )
    label.text = model.title
    stack.addArrangedSubview(label)
    stack.addSpacing()
    self.buildViews(stack: stack, views: views)
  }
  
  func buildViews(stack: UIStackView, views: [UIView]?) {
    guard let views = views else {
      return
    }
    
    for view in views {
      stack.addArrangedSubview(view)
      stack.addSpacing(Constant.Styled.Row.RepeatOtherDays.stackSpacing)
    }
  }
}
