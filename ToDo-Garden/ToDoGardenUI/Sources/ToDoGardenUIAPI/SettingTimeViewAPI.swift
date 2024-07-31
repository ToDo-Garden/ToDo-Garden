//
//  SettingTimeViewAPI.swift
//
//
//  Created by Wood on 7/31/24.
//

import UIKit.UIView

public protocol SettingTimeViewAPI: UIView {
  var seconds: Double { get }

  func transformSeconds(completion: @escaping (Double) -> Void)
  func updateSelectedTime(hour: Int, minute: Int, seconds: Int)
}
