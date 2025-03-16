//
//  StaticDataForGuide.swift
//  ShareGardenScene
//
//  Created by SONG on 3/14/25.
//

import Foundation

import ToDoGardenUIComponent

extension PomodoroRecordCollection {
  public static let fixedGardenView: PomodoroRecordCollection = {
    let calendar = Calendar.current
    let today = Date()
    
    let fixedCounts: [Int] = [
      3, 5, 12, 7, 10, 8, 1, 0, 4, 6, 9, 11, 13, 2, 15, 14, 7, 3, 8, 10,
      5, 9, 6, 12, 11, 4, 1, 0, 14, 15, 3, 8, 7, 10, 5, 9, 6, 12, 11, 4,
      2, 13, 0, 1, 15, 14, 3, 7, 8, 10, 5, 9, 6, 12, 11, 4, 1, 0, 14, 15,
      3, 8, 7, 10, 5, 9, 6, 12, 11, 4, 2, 13, 0, 1, 15, 14, 3, 7, 8, 10,
      5, 9, 6, 12, 11, 4, 1, 0, 14, 15, 3, 8, 7, 10, 5, 9, 6, 12, 11, 4,
      2, 13, 0, 1, 15, 14, 3, 7, 8, 10, 5, 9, 6, 12, 11, 4, 1, 0, 14, 15,
      3, 8, 7, 10, 5, 9, 6, 12, 11, 4, 2, 13, 0, 1, 15, 14, 3, 7, 8, 10
    ]
    
    let records: [PomodoroRecord] = (0..<140).map { dayOffset in
      guard let date = calendar.date(byAdding: .day, value: -dayOffset, to: today) else {
        return PomodoroRecord(date: Date(), pomodoroCount: Int.zero)
      }
      
      let pomodoroCount = fixedCounts[dayOffset % fixedCounts.count]
      return PomodoroRecord(date: date, pomodoroCount: pomodoroCount)
    }
    
    return PomodoroRecordCollection(pomodoroRecords: records)
  }()
}
