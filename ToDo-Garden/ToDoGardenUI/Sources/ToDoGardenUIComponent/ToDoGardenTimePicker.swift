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
    self.delegate = self
    self.dataSource = self
    self.backgroundColor = UIColor.clear
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

extension ToDoGardenTimePicker: UIPickerViewDelegate {
  public func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
    return self.configuration.dataStore.pickerView.rowHeight
  }
  
  public func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
    return self.configuration.dataStore.pickerView.widthForComponent
  }
}

extension ToDoGardenTimePicker: UIPickerViewDataSource {
  public func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return self.configuration.dataStore.pickerView.numberOfComponents
  }
  
  public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return self.configuration.dataStore.pickerView.numberOfRowsInComponent[component]
  }
  
  public func pickerView(
    _ pickerView: UIPickerView,
    viewForRow row: Int,
    forComponent component: Int,
    reusing view: UIView?
  ) -> UIView {
    let view = UILabel()
    view.textAlignment = NSTextAlignment.center
    view.text = String(row)
    view.font = UIFont.pretendardHeadBold
    view.textColor = UIColor.toDoGardenGreenDark
    return view
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
    label.attributedText = text.applyTextAttributes()
    return label
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
