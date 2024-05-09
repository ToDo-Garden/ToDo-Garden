//
//  File.swift
//  
//
//  Created by SONG on 5/9/24.
//

import Foundation

extension Constant.SettingTimeView {
  private enum Content {
    static let focusTimeTitle: String = "집중시간 설정"
    static let breakTimeTitle: String = "휴식시간 설정"
    static let notificationTimeTitle: String = "시간 설정"
  }
  
  private enum Layout {
    static let titleTopMargin: CGFloat = 44.0
    static let buttonTopMargin: CGFloat = 335.0
  }
}

extension Constant.SettingTimeView {
  public struct DataStore {
    public let title: Title
    public let timePicker: TimePicker
    public let button: Button
  }
  public struct Title {
    public let topMargin: CGFloat
    public let text: String
  }
  
  public enum TimePicker {
    case focusTime
    case breakTime
    case alarmTime
    
    public var dataStore: TimePicker.DataStore {
      switch self {
      case TimePicker.alarmTime:
        return TimePicker.DataStore()
        
      case TimePicker.focusTime:
        return TimePicker.DataStore()
        
      case TimePicker.breakTime:
        return TimePicker.DataStore()
      }
    }
  }
  
  public struct Button {
    public let topMargin: CGFloat
  }
}

extension Constant.SettingTimeView.TimePicker {
  public struct DataStore {}
}
