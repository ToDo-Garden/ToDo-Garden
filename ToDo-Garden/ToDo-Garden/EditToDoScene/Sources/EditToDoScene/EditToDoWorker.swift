//
//  EditToDoWorker.swift
//  
//
//  Created by Wood on 6/29/24.
//  Copyright (c) 2024 ToDoGarden. All rights reserved.

import Foundation

import EditToDoSceneAPI

public struct EditToDoWorker: EditToDoWorkable {
  private var calendar: Calendar

  public init(calendar: Calendar) {
    self.calendar = calendar
  }

  public func makeDate(from seconds: Double) -> Date? {
    guard 0 <= seconds && seconds < 86400
    else { return nil }

    let secondsToInt = Int(seconds)
    let hour = secondsToInt / 3600
    let minute = (secondsToInt % 3600) / 60
    let dateComponents = DateComponents(hour: hour, minute: minute)
    return self.calendar.date(from: dateComponents)
  }
}
