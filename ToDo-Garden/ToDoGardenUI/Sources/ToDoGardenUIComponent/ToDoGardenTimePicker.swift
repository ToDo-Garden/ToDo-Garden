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
  
  public func selectedTime() -> Date? {
    let calendar = Calendar.current
    var dateComponents = calendar.dateComponents(
      [
        Calendar.Component.year,
        Calendar.Component.month,
        Calendar.Component.day,
        Calendar.Component.hour,
        Calendar.Component.minute,
        Calendar.Component.second
      ],
      from: Date()
    )
    for component in 0..<self.numberOfComponents {
      let selectedRow = self.selectedRow(inComponent: component)
      switch component {
      case 0:
        dateComponents.hour? += selectedRow
      case 1:
        dateComponents.minute? += selectedRow
      case 2:
        dateComponents.second? += selectedRow
      default: break
      }
    }
    return calendar.date(from: dateComponents)
  }
  
  private func addHighlightedView() {
    let highlightedView = HighlightedView(configuration: self.configuration.dataStore)
    
    self.addSubview(highlightedView)
    
    highlightedView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate(
      [
        highlightedView.leadingAnchor.constraint(
          equalTo: self.leadingAnchor,
          constant: self.configuration.dataStore.highlightedView.leading
        ),
        highlightedView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
        highlightedView.trailingAnchor.constraint(
          equalTo: self.trailingAnchor,
          constant: self.configuration.dataStore.highlightedView.trailing
        ),
        highlightedView.heightAnchor.constraint(equalToConstant: self.configuration.dataStore.highlightedView.height)
      ]
    )
  }
}

final private class HighlightedView: UIView {
  init(configuration: Constant.SettingTimeView.TimePicker.DataStore) {
    super.init(frame: CGRect.zero)
    self.backgroundColor = UIColor.toDoGardenGreenBackground
    self.layer.cornerRadius = configuration.highlightedView.cornerRadius
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

fileprivate extension String {
  func applyTextAttributes() -> NSAttributedString {
    let attributedString = NSAttributedString(
      string: self,
      attributes: [
        NSAttributedString.Key.font: UIFont.pretendardHeadBold,
        NSAttributedString.Key.foregroundColor: UIColor.toDoGardenGreenDark
      ]
    )
    return attributedString
  }
}
