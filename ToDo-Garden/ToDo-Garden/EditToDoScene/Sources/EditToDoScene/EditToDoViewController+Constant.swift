import Foundation

extension EditToDoViewController {
  enum Constant {}
}

extension EditToDoViewController.Constant {
  enum Layout {}
  enum StringLiteral {}
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
  enum RepetitionLabel {}
  enum RepeatOnlyTodayButton {}
  enum RepeatOtherDaysView {}
}

extension EditToDoViewController.Constant.Layout.ToDoScheduleView.AlarmTimeSettingView {
  static let topMargin: CGFloat = 7
  static let height: CGFloat = 53
}

extension EditToDoViewController.Constant.Layout.ToDoScheduleView.RepetitionLabel {
  static let topMargin: CGFloat = 50
  static let leadingMargin: CGFloat = 3
}

extension EditToDoViewController.Constant.Layout.ToDoScheduleView.RepeatOnlyTodayButton {
  static let topMargin: CGFloat = 10
}

extension EditToDoViewController.Constant.Layout.ToDoScheduleView.RepeatOtherDaysView {
  static let topMargin: CGFloat = 11
}

extension EditToDoViewController.Constant.StringLiteral {
  static let title = "ToDo 편집"
}
