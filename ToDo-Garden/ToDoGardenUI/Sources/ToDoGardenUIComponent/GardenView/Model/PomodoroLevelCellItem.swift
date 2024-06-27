//
//  PomodoroLevelCellItem.swift
//
//
//  Created by Noah on 6/6/24.
//

import UIKit

/// CollectionView DataSource의 Item으로 사용될 객체입니다.
struct PomodoroLevelCellItem: Hashable {
  private let id = UUID()
  let pomodoroLevel: PomodoroLevel
  
  init(pomodoroLevel: PomodoroLevel) {
    self.pomodoroLevel = pomodoroLevel
  }
  
  func hash(into hasher: inout Hasher) {
    hasher.combine(self.id)
  }
}
