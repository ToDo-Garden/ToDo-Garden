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
        return TimePicker.DataStore(
          highlightedView: HighlightedView(
            leading: 40.0,
            trailing: -20.0,
            height: 33.0
          ),
          hourUnitLabel: HourUnitLabel(
            text: Content.hour,
            leading: 34.0
          ),
          minuteUnitLabel: MinuteUnitLabel(
            text: Content.minute,
            leading: 15.0
          ),
          secondUnitLabel: nil,
          pickerView: PickerView(
            topMargin: 95.0,
            width: 214.0,
            height: 216.0,
            rowHeight: 43.0,
            numberOfComponents: 2,
            numberOfRowsInComponent: [24, 60]
          )
        )
        
      case TimePicker.focusTime:
        return TimePicker.DataStore(
          highlightedView: HighlightedView(
            leading: 40.0,
            trailing: -20.0,
            height: 33.0
          ),
          hourUnitLabel: HourUnitLabel(
            text: Content.hour,
            leading: 34.0
          ),
          minuteUnitLabel: MinuteUnitLabel(
            text: Content.minute,
            leading: 15.0
          ),
          secondUnitLabel: SecondUnitLabel(
            text: Content.second,
            leading: -7.0
          ),
          pickerView: PickerView(
            topMargin: 95.0,
            width: 320.0,
            height: 216.0,
            rowHeight: 43.0,
            numberOfComponents: 3,
            numberOfRowsInComponent: [24, 60, 60]
          )
        )
        
      case TimePicker.breakTime:
        return TimePicker.DataStore(
          highlightedView: HighlightedView(
            leading: 40.0,
            trailing: -20.0,
            height: 33.0
          ),
          hourUnitLabel: HourUnitLabel(
            text: Content.hour,
            leading: 34.0
          ),
          minuteUnitLabel: MinuteUnitLabel(
            text: Content.minute,
            leading: 15.0
          ),
          secondUnitLabel: SecondUnitLabel(
            text: Content.second,
            leading: -7.0
          ),
          pickerView: PickerView(
            topMargin: 95.0,
            width: 320.0,
            height: 216.0,
            rowHeight: 43.0,
            numberOfComponents: 3,
            numberOfRowsInComponent: [2, 60, 60]
          )
        )
      }
    }
  }
  
  public struct Button {
    public let topMargin: CGFloat
  }
}

extension Constant.SettingTimeView.TimePicker {
  private enum Content {
    static let hour = "시간"
    static let minute = "분"
    static let second = "초"
  }
  
  public struct DataStore {
    public let highlightedView: HighlightedView
    public let hourUnitLabel: HourUnitLabel
    public let minuteUnitLabel: MinuteUnitLabel
    public let secondUnitLabel: SecondUnitLabel?
    public let pickerView: PickerView
  }
  
  public struct HighlightedView {
    public let leading: CGFloat
    public let trailing: CGFloat
    public let height: CGFloat
  }
  
  public struct HourUnitLabel {
    public let text: String
    public let leading: CGFloat
  }
  
  public struct MinuteUnitLabel {
    public let text: String
    public let leading: CGFloat
  }
  
  public struct SecondUnitLabel {
    public let text: String
    public let leading: CGFloat
  }
  
  public struct PickerView {
    public let topMargin: CGFloat
    public let width: CGFloat
    public let height: CGFloat
    public let rowHeight: CGFloat
    public let numberOfComponents: Int
    public let numberOfRowsInComponent: [Int]
  }
}
