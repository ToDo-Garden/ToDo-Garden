//
//  Constant+ToDoGardenAlertView.swift
//
//
//  Created by SONG on 4/30/24.
//

import Foundation

extension Constant.ToDoGardenAlertView {
  public enum Alpha {}
  
  public enum Content {
    case welldone
    case askToStop
    case fullyCharged
    case askToDeleteToDo
    case askToDeleteGroup
    case askToUnsubscribe
    case askToLogout
  }
}

extension Constant.ToDoGardenAlertView.Alpha {
  public static let touchedAlpha = 0.7
  public static let normalAlpha = 1.0
}
