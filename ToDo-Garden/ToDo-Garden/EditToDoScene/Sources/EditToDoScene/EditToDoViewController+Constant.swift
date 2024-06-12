import Foundation

extension EditToDoViewController {
  enum Constant {}
}

extension EditToDoViewController.Constant {
  enum Layout {}
}

extension EditToDoViewController.Constant.Layout {
  enum CompleteEditingButton {}
  enum EditModeSegmentedControl {}
  enum ToDoScheduleView {}
}

extension EditToDoViewController.Constant.Layout.CompleteEditingButton {
  static let bottomMargin: CGFloat = 13
}

extension EditToDoViewController.Constant.Layout.EditModeSegmentedControl {
  static let topMargin: CGFloat = 10
  static let leadingMargin: CGFloat = 12
  static let trailingMargin: CGFloat = 13
  static let height: CGFloat = 49
}

extension EditToDoViewController.Constant.Layout.ToDoScheduleView {
  static let topMargin: CGFloat = 40
  static let leadingMargin: CGFloat = 30
  static let traillingMargin: CGFloat = 30
  static let bottomMargin: CGFloat = 150
}

extension EditToDoViewController.Constant.Layout.ToDoScheduleView {
  enum AlarmTimeSettingView {}
}

extension EditToDoViewController.Constant.Layout.ToDoScheduleView.AlarmTimeSettingView {
  static let topMargin: CGFloat = 7
  static let height: CGFloat = 53
}
