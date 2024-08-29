//
//  PomodoroRecord.swift
//
//
//  Created by Noah on 6/13/24.
//

import Foundation

public struct PomodoroRecord: Sendable {
  let date: Date
  let pomodoroCount: Int
  
  public init(date: Date, pomodoroCount: Int) {
    self.date = date
    self.pomodoroCount = pomodoroCount
  }
}
