//
//  AlarmTimeView.swift
//
//
//  Created by Wood on 5/10/24.
//

import UIKit

import ToDoGardenUIConstant
import ToDoGardenUIResource

public final class AlarmTimeView: UIView {
  private var model: AlarmTimeView.Model
  private var timeLabel: UILabel
  private var alarmSettingButton: UIButton

  public init(model: AlarmTimeView.Model) {
    self.model = model
    self.timeLabel = UILabel()
    self.alarmSettingButton = UIButton()
    super.init(frame: CGRect.zero)
    self.setup()
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: Private Functions

extension AlarmTimeView {
  private func setup() {
    self.setupBorder()
    self.setupTimeLabel()
    self.setupAlarmSettingButton()
  }

  private func setupBorder() {
    self.layer.cornerRadius = self.model.cornerRadius
    self.layer.borderWidth = self.model.borderWidth
    self.layer.borderColor = UIColor.toDoGardenGreenDark.cgColor
  }

  private func setupTimeLabel() {
    self.timeLabel.text = self.model.labelText
    self.timeLabel.font = UIFont.pretendardBodySemiBold
    self.timeLabel.textColor = UIColor.toDoGardenGreenDark
  }

  private func setupAlarmSettingButton() {
    self.setupAlarmSettingButtonConfiguration()
    self.setupAlarmSettingButtonUpdateHandler()
    self.setupAlarmSettingButtonTitle(with: self.model.alarmTime)
  }

  private func setupAlarmSettingButtonConfiguration() {
    var configuration = UIButton.Configuration.filled()
    configuration.contentInsets = model.contentInsets
    configuration.baseBackgroundColor = UIColor.toDoGardenGreenBackground
    self.alarmSettingButton.configuration = configuration
  }

  private func setupAlarmSettingButtonUpdateHandler() {
    self.alarmSettingButton.configurationUpdateHandler = { button in
      switch button.state {
      case UIControl.State.normal:
        button.configuration?.attributedTitle?.foregroundColor = UIColor.toDoGardenGreenDark
        button.configuration?.baseBackgroundColor = UIColor.toDoGardenGreenBackground
      case UIControl.State.disabled:
        button.configuration?.attributedTitle?.foregroundColor = UIColor.toDoGardenGray3
      default:
        break
      }
    }
  }

  private func setupAlarmSettingButtonTitle(with text: String) {
    let attributes = AttributeContainer(
      [
        NSAttributedString.Key.font: UIFont.pretendardBodyMedium,
        NSAttributedString.Key.foregroundColor: UIColor.toDoGardenGreenDark
      ]
    )
    let attributedTitle = AttributedString(text, attributes: attributes)
    self.alarmSettingButton.configuration?.attributedTitle = attributedTitle
  }
}

// MARK: Model

extension AlarmTimeView {
  public struct Model {
    let labelText: String
    let alarmTime: String
    let borderWidth: CGFloat
    let cornerRadius: CGFloat
    let contentInsets: NSDirectionalEdgeInsets

    public static let primary = Self(
      labelText: Constant.AlarmTimeView.StringLiteral.TimeLabel.defaultText,
      alarmTime: Constant.AlarmTimeView.StringLiteral.AlarmSettingButton.defaultTimeText,
      borderWidth: Constant.AlarmTimeView.Layout.borderWidth,
      cornerRadius: Constant.AlarmTimeView.Layout.cornerRadius,
      contentInsets: NSDirectionalEdgeInsets(
        top: Constant.AlarmTimeView.Layout.AlarmSettingButton.ContentInsets.top,
        leading: Constant.AlarmTimeView.Layout.AlarmSettingButton.ContentInsets.leading,
        bottom: Constant.AlarmTimeView.Layout.AlarmSettingButton.ContentInsets.bottom,
        trailing: Constant.AlarmTimeView.Layout.AlarmSettingButton.ContentInsets.trailing
      )
    )
  }
}
