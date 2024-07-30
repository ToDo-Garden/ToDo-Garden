//
//  SettingTimeView.swift
//
//
//  Created by SONG on 5/30/24.
//

import UIKit

import ToDoGardenUIConstant
import ToDoGardenUIResource

public class SettingTimeView: UIView {
  private var configuration: Configuration
  private let timepicker: ToDoGardenTimePicker
  private let button: UIButton
  
  public init(with button: UIButton, for configuration: Configuration) {
    self.configuration = configuration
    self.timepicker = ToDoGardenTimePicker(configuration: self.configuration.dataStore.timePicker)
    self.button = button
    super.init(frame: CGRect.zero)
    self.build()
    self.backgroundColor = .white
  }
  
  @available(*, unavailable)
  public required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override public var intrinsicContentSize: CGSize {
    let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
    let screenWidth = windowScene?.screen.bounds.width ?? 1.0
    let screenHeight = windowScene?.screen.bounds.height ?? 1.0
    return CGSize.init(width: screenWidth, height: screenHeight / 2)
  }
  
  public var seconds: Double {
    self.timepicker.transformSeconds()
  }
  
  public func transformSeconds(completion: @escaping (Double) -> Void) {
    let calculatedDate = self.timepicker.transformSeconds()
    completion(calculatedDate)
  }

  public func updateSelectedTime(hour: Int, minute: Int, seconds: Int = 0) {
    self.timepicker.updateSelectedTime(hour: hour, minute: minute, seconds: seconds)
  }
}

extension SettingTimeView {
  private func build() {
    self.buildTitleLabel()
    self.buildTimePicker()
    self.buildButton()
  }
  
  private func buildTitleLabel() {
    let titleLabel = UILabel()
    let multiplier = Constant.SettingTimeView.Layout.titleTopMarginMultiplier
    let topMargin = self.intrinsicContentSize.height / multiplier
    
    titleLabel.text = self.configuration.dataStore.title.text
    titleLabel.font = UIFont.pretendardHeadBold
    titleLabel.textColor = UIColor.toDoGardenBlack
    self.addSubview(titleLabel)
    
    titleLabel.usingAutolayout()
    NSLayoutConstraint.activate(
      [
        titleLabel.topAnchor.constraint(
          equalTo: self.topAnchor,
          constant: topMargin
        ),
        titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor)
      ]
    )
  }
  
  private func buildTimePicker() {
    let multiplier = Constant.SettingTimeView.Layout.timePickertopMarginMultiplier
    let topMargin = self.intrinsicContentSize.height / multiplier
    self.timepicker.delegate = self
    self.timepicker.dataSource = self
    self.timepicker.setInitialSelection()
    self.addSubview(self.timepicker)
    
    self.timepicker.usingAutolayout()
    NSLayoutConstraint.activate(
      [
        self.timepicker.topAnchor.constraint(
          equalTo: self.topAnchor,
          constant: topMargin
        ),
        self.timepicker.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: -3)
      ]
    )
  }
  
  private func buildButton() {
    self.addSubview(self.button)
    self.button.usingAutolayout()
    
    let dummyView = UIView()
    dummyView.usingAutolayout()
    self.addSubview(dummyView)
    let dummyTopAnchorConstant = Constant.SettingTimeView.Layout.dummyViewTopWeight
    
    NSLayoutConstraint.activate([
      dummyView.topAnchor.constraint(
        equalTo: self.timepicker.bottomAnchor,
        constant: dummyTopAnchorConstant
      ),
      dummyView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
      dummyView.widthAnchor.constraint(equalToConstant: CGFloat.zero),
      dummyView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
      self.button.centerXAnchor.constraint(equalTo: self.centerXAnchor),
      self.button.centerYAnchor.constraint(equalTo: dummyView.centerYAnchor)
    ])
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
  public static let focusTimeSetting: Self = SettingTimeView.Configuration.init(
    dataStore: Constant.SettingTimeView.focusTimeSetting
  )
  
  public static let breakTimeSetting: Self = SettingTimeView.Configuration.init(
    dataStore: Constant.SettingTimeView.breakTimeSetting
  )
  
  public static let alarmTimeSetting: Self =
  SettingTimeView.Configuration.init(
    dataStore: Constant.SettingTimeView.alarmTimeSetting
  )
}

extension SettingTimeView: UIPickerViewDelegate {
  private var timePickerConstant: Constant.SettingTimeView.TimePicker.DataStore {
    return self.configuration.dataStore.timePicker.dataStore
  }
  
  public func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
    return self.timePickerConstant.pickerView.rowHeight
  }
  
  public func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
    return self.timePickerConstant.pickerView.widthForComponent
  }
  
  public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    self.button.isEnabled = self.timepicker.transformSeconds() >= Constant.SettingTimeView.minimumTimeInterval
  }
}

extension SettingTimeView: UIPickerViewDataSource {
  public func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return self.timePickerConstant.pickerView.numberOfComponents
  }
  
  public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return self.timePickerConstant.pickerView.numberOfRowsInComponent[component]
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

#if DEBUG
@available(iOS 17.0, *)
#Preview {
  let button = ToDoGardenBoxButton(title: "asdasd", buttonType: .primaryRoundRectButton)
  
  let view = SettingTimeView(with: button, for: .alarmTimeSetting)
  view.updateSelectedTime(hour: 20, minute: 18)

  let action = UIAction { _ in
    view.transformSeconds { time in print(time) }
  }
  
  button.addAction(action, for: .touchUpInside)
  
  return view
}
#endif
