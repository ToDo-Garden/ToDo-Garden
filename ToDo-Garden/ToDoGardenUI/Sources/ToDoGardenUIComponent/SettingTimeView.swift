//
//  SettingTimeView.swift
//
//
//  Created by SONG on 5/30/24.
//

import UIKit

import ToDoGardenUIConstant

public class SettingTimeView: UIView {
  private var configuration: Configuration
  private let timepicker: ToDoGardenTimePicker
  
  public init(with button: UIButton, for configuration: Configuration) {
    self.configuration = configuration
    self.timepicker = ToDoGardenTimePicker(configuration: self.configuration.dataStore.timePicker)
    super.init(frame: CGRect.zero)
    self.build(with: button)
  }
  
  @available(*, unavailable)
  public required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override public var intrinsicContentSize: CGSize {
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    return CGSize.init(width: screenWidth, height: screenHeight / 2)
  }
  
  public func calculateDate(completion: @escaping (Date) -> Void) {
    let calculatedDate = self.timepicker.calculateDate()
    completion(calculatedDate)
  }
}

extension SettingTimeView {
  private func build(with button: UIButton) {
    
  }
}

extension SettingTimeView {
  public struct Configuration {
    let dataStore: Constant.SettingTimeView.DataStore
    
    init(dataStore: Constant.SettingTimeView.DataStore) {
      self.dataStore = dataStore
    }
  }
}

extension SettingTimeView.Configuration {

}
