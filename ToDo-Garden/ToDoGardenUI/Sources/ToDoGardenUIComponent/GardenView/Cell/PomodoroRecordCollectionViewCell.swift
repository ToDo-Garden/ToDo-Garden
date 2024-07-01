//
//  PomodoroRecordCollectionViewCell.swift
//
//
//  Created by Noah on 6/7/24.
//

import UIKit

import ToDoGardenUIResource

final class PomodoroRecordCollectionViewCell: UICollectionViewCell {
  private let firstDayOfMonthLabel: UILabel = {
    let firstDayOfMonthLabel = UILabel()
    firstDayOfMonthLabel.font = UIFont.pretendardDetailRegular5
    firstDayOfMonthLabel.textColor = UIColor.black
    firstDayOfMonthLabel.textAlignment = NSTextAlignment.center
    
    return firstDayOfMonthLabel
  }()
  
  private let pomodoroLevelsView: PomodoroLevelCollectionView = {
    let pomodoroLevelsView = PomodoroLevelCollectionView()
    pomodoroLevelsView.showsHorizontalScrollIndicator = false
    pomodoroLevelsView.showsVerticalScrollIndicator = false
    pomodoroLevelsView.isScrollEnabled = false
    
    return pomodoroLevelsView
  }()
}
