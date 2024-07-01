//
//  ToDoGardenTimePicker.swift
//
//
//  Created by SONG on 5/20/24.
//

import UIKit

import FoundationExtension
import ToDoGardenUIConstant

final public class ToDoGardenTimePicker: UIPickerView {
  private let configuration: Constant.SettingTimeView.TimePicker
  private let timeBuilder: TimeBuilder
  
  public init(
    configuration: Constant.SettingTimeView.TimePicker,
    timeBuilder: TimeBuilder = TimeBuilder()
  ) {
    self.configuration = configuration
    self.timeBuilder = timeBuilder
    super.init(frame: CGRect.zero)
    self.backgroundColor = UIColor.clear
    self.hideDefaultHighlightedView()
    self.addHighlightedView()
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override public func layoutSubviews() {
    super.layoutSubviews()
    if let highlightedView = self.subviews.last(where: { $0 is HighlightedView }) {
      self.sendSubviewToBack(highlightedView)
    }
  }
  
  override public var intrinsicContentSize: CGSize {
    return self.configuration.dataStore.pickerView.size
  }
  
  func transformSeconds() -> Double {
    var components = [Int]()
    for index in Int.zero..<self.numberOfComponents {
      components.append(self.selectedRow(inComponent: index))
    }
    return self.timeBuilder.buildTimeInterval(from: components)
  }
  
  func setInitialSelection() {
    self.selectRow(10, inComponent: 1, animated: false)
  }
  
  private func hideDefaultHighlightedView() {
    self.layoutIfNeeded()
    guard let defaultHighlightedView = self.subviews.last else {
      return
    }
    
    defaultHighlightedView.isHidden = true
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
    self.buildLabels(with: configuration)
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func buildLabels(with constants: Constant.SettingTimeView.TimePicker.DataStore) {
    self.setupUnitLabel(
      with: constants.hourUnitLabel.text,
      constraint: constants.hourUnitLabel.constraint
    )
    self.setupUnitLabel(
      with: constants.minuteUnitLabel.text,
      constraint: constants.minuteUnitLabel.constraint
    )
    
    guard let secondLabelConstants = constants.secondUnitLabel else {
      return
    }
    
    self.setupUnitLabel(
      with: secondLabelConstants.text,
      constraint: secondLabelConstants.constraint
    )
  }
  
  private func setupUnitLabel(
    with text: String,
    constraint: Constant.SettingTimeView.TimePicker.Constraint
  ) {
    let label = createLabel(with: text)
    label.usingAutolayout()
    self.addSubview(label)
    var layoutConstraints: [NSLayoutConstraint] = []
    
    switch constraint {
    case .leading(let value):
      layoutConstraints.append(
        label.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: value)
      )
    case .centerX(let value):
      layoutConstraints.append(
        label.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: value)
      )
    case .trailing(let value):
      layoutConstraints.append(
        label.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: value)
      )
    }
    layoutConstraints.append(label.centerYAnchor.constraint(equalTo: self.centerYAnchor))
    NSLayoutConstraint.activate(layoutConstraints)
  }
  
  private func createLabel(with text: String) -> UILabel {
    let label = UILabel()
    let attributes = [
      NSAttributedString.Key.font: UIFont.pretendardHeadBold,
      NSAttributedString.Key.foregroundColor: UIColor.toDoGardenGreenDark
    ]
    label.attributedText = text.applyTextAttributes(attributes: attributes)
    return label
  }
}

public class TimeBuilder {
  public init() {}

  public func buildTimeInterval(from components: [Int]) -> Double {
    let hours = components[0]
    let minutes = components[1]
    let seconds = components.count > 2 ? components[2] : 0
    return Double(hours * 3600 + minutes * 60 + seconds)
  }
}
