//
//  ToDoGardenTimePicker.swift
//
//
//  Created by SONG on 5/20/24.
//

import UIKit

import ToDoGardenUIConstant

final public class ToDoGardenTimePicker: UIPickerView {
  private let configuration: Constant.SettingTimeView.TimePicker
  
  public init(configuration: Constant.SettingTimeView.TimePicker) {
    self.configuration = configuration
    super.init(frame: CGRect.zero)
    self.backgroundColor = UIColor.clear
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override public func layoutSubviews() {
    super.layoutSubviews()
    guard !self.subviews.isEmpty else {
      return
    }
    
    self.subviews[Int.zero].backgroundColor = UIColor.clear
    
    guard let lastSubview = self.subviews.last else {
      return
    }
    
    self.sendSubviewToBack(lastSubview)
  }
  
  override public var intrinsicContentSize: CGSize {
    let width = self.configuration.dataStore.pickerView.width
    let height = self.configuration.dataStore.pickerView.height
    return CGSize(width: width, height: height)
  }
}
