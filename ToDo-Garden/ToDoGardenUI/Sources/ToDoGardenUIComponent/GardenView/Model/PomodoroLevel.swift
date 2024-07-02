//
//  PomodoroLevel.swift
//
//
//  PomodoroLevel by Noah on 6/12/24.
//

import class UIKit.UIColor

enum PomodoroLevel {
  case none
  case low
  case middle
  case high
  case perfect
  
  var color: UIColor {
    switch self {
    case PomodoroLevel.none:
      return UIColor.toDoGardenGrassNone
    case PomodoroLevel.low:
      return UIColor.toDoGardenGrassLow
    case PomodoroLevel.middle:
      return UIColor.toDoGardenGrassMiddle
    case PomodoroLevel.high:
      return UIColor.toDoGardenGrassHigh
    case PomodoroLevel.perfect:
      return UIColor.toDoGardenGrassPerfect
    }
  }
}
