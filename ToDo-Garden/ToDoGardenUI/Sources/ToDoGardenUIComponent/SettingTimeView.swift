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
    let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
    let screenWidth = windowScene?.screen.bounds.width ?? 1.0
    let screenHeight = windowScene?.screen.bounds.height ?? 1.0
    return CGSize.init(width: screenWidth, height: screenHeight / 2)
  }
  
  public func calculateDate(completion: @escaping (Date) -> Void) {
    let calculatedDate = self.timepicker.calculateDate()
    completion(calculatedDate)
  }
}

extension SettingTimeView {
  private func build(with button: UIButton) {
    self.buildTitleLabel()
    self.buildTimePicker()
    self.buildButton(with: button)
  }
  
  private func buildTitleLabel() {
    let titleLabel = UILabel()
    titleLabel.text = self.configuration.dataStore.title.text
    titleLabel.font = UIFont.pretendardHeadBold
    titleLabel.textColor = UIColor.toDoGardenBlack
    self.addSubview(titleLabel)
    
    titleLabel.usingAutolayout()
    NSLayoutConstraint.activate(
      [
        titleLabel.topAnchor.constraint(
          equalTo: self.topAnchor,
          constant: self.configuration.dataStore.title.topMargin
        ),
        titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor)
      ]
    )
  }
  
  private func buildTimePicker() {
    self.addSubview(self.timepicker)
    
    self.timepicker.usingAutolayout()
    NSLayoutConstraint.activate(
      [
        self.timepicker.topAnchor.constraint(
          equalTo: self.topAnchor,
          constant: self.configuration.dataStore.timePicker.dataStore.pickerView.topMargin
        ),
        self.timepicker.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: -3)
      ]
    )
  }
  
  private func buildButton(with button: UIButton) {
    self.addSubview(button)
    
    button.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate(
      [
        button.bottomAnchor.constraint(
          equalTo: self.bottomAnchor,
          constant: self.configuration.dataStore.button.bottomMargin
        ),
        button.centerXAnchor.constraint(equalTo: self.centerXAnchor)
      ]
    )
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

#if DEBUG
@available(iOS 17.0, *)
#Preview {
  let button = ToDoGardenBoxButton(title: "asdasd", buttonType: .primaryRoundRectButton)
  
  let view = SettingTimeView(with: button, for: .breakTimeSetting)
  
  let action = UIAction { _ in
    view.calculateDate { date in print(date) }
  }
  
  button.addAction(action, for: .touchUpInside)
  return view
}
#endif
