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
  
  /// 그룹화된 `PomodoroRecordCellItem` 배열을 반환합니다.
  /// - Parameters:
  ///   - pomodoroDates: Pomodoro 세션이 실행된 날짜 배열
  ///   - pomodoroLevels: 각 날짜에 해당하는 Pomodoro 레벨 배열
  /// - Returns: 일주일 단위로 그룹화된 `PomodoroRecordCellItem` 배열을 반환합니다. 날짜와 레벨 배열의 크기가 다르면 `nil`을 반환합니다.
  static func groupedPomodoroRecordCellItem(
    pomodoroDates: [Date],
    pomodoroLevels: [PomodoroLevel]
  ) -> [PomodoroRecordCellItem]? {
    guard pomodoroDates.count == pomodoroLevels.count
    else { return nil }
    
    var pomodoroRecordCellItems: [PomodoroRecordCellItem] = []
    
    let combined = zip(pomodoroDates, pomodoroLevels)
    
    var currentBatchDates: [Date] = []
    var currentBatchLevels: [PomodoroLevel] = []
    
    let daysOfWeek = 7
    
    for (date, level) in combined {
      currentBatchDates.append(date)
      currentBatchLevels.append(level)
      
      if currentBatchDates.count == daysOfWeek {
        let recordItem = PomodoroRecordCellItem(dates: currentBatchDates, pomodoroLevels: currentBatchLevels)
        pomodoroRecordCellItems.append(recordItem)
        
        currentBatchDates.removeAll()
        currentBatchLevels.removeAll()
      }
    }
    
    return pomodoroRecordCellItems
  }
}
