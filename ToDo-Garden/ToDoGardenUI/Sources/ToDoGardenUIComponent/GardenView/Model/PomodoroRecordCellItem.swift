//
//  PomodoroRecordCellItem.swift
//
//
//  Created by Noah on 6/8/24.
//

import Foundation

/// CollectionView DataSource의 Item으로 사용될 객체입니다.
struct PomodoroRecordCellItem: Hashable {
  private let id = UUID()
  private let dates: [Date]
  let pomodoroLevels: [PomodoroLevel]
  
  init(dates: [Date], pomodoroLevels: [PomodoroLevel]) {
    self.dates = dates
    self.pomodoroLevels = pomodoroLevels
  }
  
  func hash(into hasher: inout Hasher) {
    hasher.combine(self.id)
  }
}
