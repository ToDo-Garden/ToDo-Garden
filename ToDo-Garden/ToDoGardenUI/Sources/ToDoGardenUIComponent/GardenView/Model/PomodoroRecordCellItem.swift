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
  
  /// 인스턴스의 날짜 목록에서 해당 월의 첫 번째 날짜를 포매팅된 문자열로 반환합니다.
  ///
  /// `PomodoroRecordCellItem`인스턴스의 `dates`를 Set으로 변환한 후 순회하며 각 날짜의 해당 월 첫 번째 날짜가 배열에 포함되어 있는지 확인합니다.
  /// 배열의 `contains(_:)` 메서드는 O(n) Set의 `contains(_:)`는 O(1)이므로, Set으로 변환하였습니다.
  /// 만약 그러한 날짜를 찾으면, 이 날짜를 "M/d" 형식의 문자열로 변환하여 반환합니다. 해당 날짜를 찾지 못하면 `nil`을 반환합니다.
  ///
  /// - Returns: "M/d" 형식의 문자열로 표현된 해당 월의 첫 번째 날짜, 해당 날짜를 찾지 못한 경우 `nil`을 반환합니다.
  func formattedFirstDayOfMonth() -> String? {
    let dateFormatStyle = Date.FormatStyle()
      .month(Date.FormatStyle.Symbol.Month.defaultDigits)
      .day(Date.FormatStyle.Symbol.Day.defaultDigits)
    let dateSet = Set(self.dates)
    
    for date in self.dates {
      if let firstDayOfMonth = self.firstDayOfMonth(from: date), dateSet.contains(firstDayOfMonth) {
        return firstDayOfMonth.formatted(dateFormatStyle)
      }
    }
    
    return nil
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

extension PomodoroRecordCellItem {
  /// 주어진 날짜의 해당 월의 첫 번째 날짜를 반환합니다.
  ///
  /// 주어진 날짜에서 연도와 월을 추출하고, 해당 월의 첫 번째 날을 나타내는 날짜를 반환합니다.
  ///
  /// - Parameter date: 기준이 되는 날짜.
  /// - Returns: 해당 월의 첫 번째 날짜, 생성할 수 없는 경우 `nil`을 반환합니다.
  private func firstDayOfMonth(from date: Date) -> Date? {
    let calendar = Calendar.current
    var components = calendar.dateComponents(
      [
        Calendar.Component.year,
        Calendar.Component.month
      ],
      from: date
    )
    components.day = 1
    
    return calendar.date(from: components)
  }
}
