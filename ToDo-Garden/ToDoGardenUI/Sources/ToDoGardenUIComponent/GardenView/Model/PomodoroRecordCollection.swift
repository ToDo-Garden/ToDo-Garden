//
//  PomodoroRecordCollection.swift
//
//
//  Created by Noah on 6/26/24.
//

import Foundation

/// PomodoroRecord 객체를 저장하는 first class collection입니다.
public struct PomodoroRecordCollection {
  private var pomodoroRecords: [PomodoroRecord]
  private var maxPomodoroCount: Int?
  
  public init(pomodoroRecords: [PomodoroRecord] = [PomodoroRecord]()) {
    self.pomodoroRecords = pomodoroRecords
    self.maxPomodoroCount = self.pomodoroRecords.max { lhs, rhs in
      lhs.pomodoroCount < rhs.pomodoroCount
    }?.pomodoroCount
  }
}
