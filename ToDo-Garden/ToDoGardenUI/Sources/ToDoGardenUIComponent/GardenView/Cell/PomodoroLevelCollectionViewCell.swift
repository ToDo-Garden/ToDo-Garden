//
//  PomodoroLevelCollectionViewCell.swift
//
//
//  Created by Noah on 6/6/24.
//

import UIKit

import ToDoGardenUIConstant
import ToDoGardenUIResource

import TDUtility

final class PomodoroLevelCollectionViewCell: UICollectionViewCell {
  @ExecuteOnce private var setupLayoutIfNeeded: (() -> Void)?
  
  override func layoutSubviews() {
    super.layoutSubviews()
    self.setupLayoutIfNeeded = {
      self.setupCornerRadius()
    }
  }
}

extension PomodoroLevelCollectionViewCell {
  private func setupCornerRadius() {
    let cornerRadiusRatio = Constant.PomodoroLevelCollectionViewCell.Layout.cornerRadiusRatio
    self.layer.cornerRadius = self.bounds.width * cornerRadiusRatio
    self.layer.masksToBounds = true
  }
}
