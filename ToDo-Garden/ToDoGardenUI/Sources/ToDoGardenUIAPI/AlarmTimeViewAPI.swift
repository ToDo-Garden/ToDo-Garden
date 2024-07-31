//
//  AlarmTimeViewAPI.swift
//
//
//  Created by Wood on 7/31/24.
//

import UIKit.UIView

public protocol AlarmTimeViewAPI: UIView {
  var delegate: AlarmTimeViewDelegate? { get set }

  func enable()
  func disable()
  func updateAlarmTime(with text: String)
}

public protocol AlarmTimeViewDelegate: AnyObject {
  func didSelectAlarmTimeSettingButton()
}
