//
//  Constant+SettingTimeView.swift
//
//
//  Created by SONG on 5/9/24.
//

import Foundation

extension Constant.SettingTimeView {
  public static let minimumTimeInterval: Double = 600.0
  
  private enum StringLiteral {
    static let focusTimeTitle: String = "집중시간 설정"
    static let breakTimeTitle: String = "휴식시간 설정"
    static let alarmTimeTitle: String = "시간 설정"
  }
  
  public enum Layout {
    public static let titleTopMarginMultiplier: CGFloat = 11.63
    public static let timePickertopMarginMultiplier: CGFloat = 5.85
    public static let dummyViewTopWeight: CGFloat = -20
  }
}

extension Constant.SettingTimeView {
  public struct DataStore {
    public let title: Title
    public let timePicker: TimePicker
  }
  
  public struct Title {
    public let text: String
  }
  
  public enum TimePicker {
    case focusTime
    case breakTime
    case alarmTime
    
    public var dataStore: TimePicker.DataStore {
      switch self {
      case TimePicker.alarmTime:
        return TimePicker.DataStore(
          highlightedView: HighlightedView(
            leading: 42.5,
            trailing: -27.5,
            height: 33.0,
            cornerRadius: 5.0
          ),
          hourUnitLabel: UnitLabel(
            text: StringLiteral.hourAlarm,
            constraint: Constraint.leading(35.0)
          ),
          minuteUnitLabel: UnitLabel(
            text: StringLiteral.minute,
            constraint: Constraint.centerX(56.0)
          ),
          secondUnitLabel: nil
          ,
          pickerView: PickerView(
            topMargin: 95.0,
            size: CGSize(width: 214.0, height: 216.0),
            rowHeight: 43.0,
            widthForComponent: 80.0,
            numberOfComponents: 2,
            numberOfRowsInComponent: [24, 60]
          )
        )
        
      case TimePicker.focusTime:
        return TimePicker.DataStore(
          highlightedView: HighlightedView(
            leading: 45.0,
            trailing: -27.5,
            height: 33.0,
            cornerRadius: 5.0
          ),
          hourUnitLabel: UnitLabel(
            text: StringLiteral.hourDefault,
            constraint: Constraint.leading(34.0)
          ),
          minuteUnitLabel: UnitLabel(
            text: StringLiteral.minute,
            constraint: Constraint.centerX(15.0)
          ),
          secondUnitLabel: UnitLabel(
            text: StringLiteral.second,
            constraint: Constraint.trailing(-7.0)
          ),
          pickerView: PickerView(
            topMargin: 95.0,
            size: CGSize(width: 320.0, height: 216.0),
            rowHeight: 43.0,
            widthForComponent: 90.0,
            numberOfComponents: 3,
            numberOfRowsInComponent: [24, 60, 60]
          )
        )
        
      case TimePicker.breakTime:
        return TimePicker.DataStore(
          highlightedView: HighlightedView(
            leading: 45.0,
            trailing: -27.5,
            height: 33.0,
            cornerRadius: 5.0
          ),
          hourUnitLabel: UnitLabel(
            text: StringLiteral.hourDefault,
            constraint: Constraint.leading(34.0)
          ),
          minuteUnitLabel: UnitLabel(
            text: StringLiteral.minute,
            constraint: Constraint.centerX(15.0)
          ),
          secondUnitLabel: UnitLabel(
            text: StringLiteral.second,
            constraint: Constraint.trailing(-7.0)
          ),
          pickerView: PickerView(
            topMargin: 95.0,
            size: CGSize(width: 320.0, height: 216.0),
            rowHeight: 43.0,
            widthForComponent: 90.0,
            numberOfComponents: 3,
            numberOfRowsInComponent: [2, 60, 60]
          )
        )
      }
    }
  }
  
  public struct Button {
  }
}

extension Constant.SettingTimeView.TimePicker {
  private enum StringLiteral {
    static let hourDefault = "시간"
    static let hourAlarm = "시"
    static let minute = "분"
    static let second = "초"
  }
  
  public enum Constraint {
    case leading(CGFloat)
    case centerX(CGFloat)
    case trailing(CGFloat)
  }
  
  public struct DataStore {
    public let highlightedView: HighlightedView
    public let hourUnitLabel: UnitLabel
    public let minuteUnitLabel: UnitLabel
    public let secondUnitLabel: UnitLabel?
    public let pickerView: PickerView
  }
  
  public struct HighlightedView {
    public let leading: CGFloat
    public let trailing: CGFloat
    public let height: CGFloat
    public let cornerRadius: CGFloat
  }
  
  public struct UnitLabel {
    public let text: String
    public let constraint: Constraint
  }
  
  public struct PickerView {
    public let topMargin: CGFloat
    public let size: CGSize
    public let rowHeight: CGFloat
    public let widthForComponent: CGFloat
    public let numberOfComponents: Int
    public let numberOfRowsInComponent: [Int]
  }
}

extension Constant.SettingTimeView {
  public static let focusTimeSetting = DataStore.init(
    title: Title(text: StringLiteral.focusTimeTitle),
    timePicker: TimePicker.focusTime
  )
  
  public static let breakTimeSetting = DataStore.init(
    title: Title(text: StringLiteral.breakTimeTitle),
    timePicker: TimePicker.breakTime
  )
  
  public static let alarmTimeSetting = DataStore.init(
    title: Title(text: StringLiteral.alarmTimeTitle),
    timePicker: TimePicker.alarmTime
  )
}
