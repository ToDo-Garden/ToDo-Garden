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

  public init(model: AlarmTimeView.Model) {
    self.model = model
    super.init(frame: CGRect.zero)
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
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
