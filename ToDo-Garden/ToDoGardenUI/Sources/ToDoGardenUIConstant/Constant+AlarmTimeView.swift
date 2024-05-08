//
//  Constant+AlarmTimeView.swift
//  
//
//  Created by Wood on 5/7/24.
//

import Foundation

extension Constant.AlarmTimeView {
  public enum Layout {}
}

extension Constant.AlarmTimeView.Layout {
  public enum TimeLabel {}
  public enum AlarmSettingButton {}
}

extension Constant.AlarmTimeView.Layout {
  public static let borderWidth: CGFloat = 1.0
  public static let cornerRadius: CGFloat = 15.5
}

extension Constant.AlarmTimeView.Layout.TimeLabel {
  public static let defaultText: String = "시간"
  public static let leadingMargin: CGFloat = 22
}

extension Constant.AlarmTimeView.Layout.AlarmSettingButton {
  public enum ContentInsets {}

  public static let defaultTimeText: String = "00:00"
  public static let trailingMargin: CGFloat = 14
}

extension Constant.AlarmTimeView.Layout.AlarmSettingButton.ContentInsets {
  public static let top: CGFloat = 4
  public static let leading: CGFloat = 10
  public static let bottom: CGFloat = 4
  public static let trailing: CGFloat = 10
}
