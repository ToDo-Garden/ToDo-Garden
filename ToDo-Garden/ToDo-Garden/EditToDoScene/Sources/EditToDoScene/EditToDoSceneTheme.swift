import Foundation

enum EditToDoSceneTheme {
  enum Constant {}
}

extension EditToDoSceneTheme.Constant {
  enum Layout {}
  enum StringLiteral {}
}

extension EditToDoSceneTheme.Constant.Layout {
  enum CompleteEditingButton {}
  enum EditModeSegmentedControl {}
  enum ToDoScheduleView {}
}

extension EditToDoSceneTheme.Constant.Layout.CompleteEditingButton {
  static let bottomMargin: CGFloat = 13
}

extension EditToDoSceneTheme.Constant.Layout.EditModeSegmentedControl {
  static let topMargin: CGFloat = 10
  static let leadingMargin: CGFloat = 12
  static let trailingMargin: CGFloat = 13
  static let height: CGFloat = 49
}

extension EditToDoSceneTheme.Constant.Layout.ToDoScheduleView {
  static let topMargin: CGFloat = 40
  static let leadingMargin: CGFloat = 30
  static let traillingMargin: CGFloat = 30
  static let bottomMargin: CGFloat = 150
}

extension EditToDoSceneTheme.Constant.Layout.ToDoScheduleView {
  enum AlarmTimeSettingView {}
  enum RepetitionLabel {}
  enum RepeatOnlyTodayButton {}
  enum RepeatOtherDaysView {}
}

extension EditToDoSceneTheme.Constant.Layout.ToDoScheduleView.AlarmTimeSettingView {
  static let topMargin: CGFloat = 7
  static let height: CGFloat = 53
}

extension EditToDoSceneTheme.Constant.Layout.ToDoScheduleView.RepetitionLabel {
  static let topMargin: CGFloat = 50
  static let leadingMargin: CGFloat = 3
}

extension EditToDoSceneTheme.Constant.Layout.ToDoScheduleView.RepeatOnlyTodayButton {
  static let topMargin: CGFloat = 10
}

extension EditToDoSceneTheme.Constant.Layout.ToDoScheduleView.RepeatOtherDaysView {
  static let topMargin: CGFloat = 11
}

extension EditToDoSceneTheme.Constant.StringLiteral {
  enum CompleteEditingButton {}
  enum EditToDoViewController {}
  enum ToDoScheduleView {}
}

extension EditToDoSceneTheme.Constant.StringLiteral.CompleteEditingButton {
  static let title = "완료"
}

extension EditToDoSceneTheme.Constant.StringLiteral.EditToDoViewController {
  static let title = "ToDo 편집"
}

extension EditToDoSceneTheme.Constant.StringLiteral.ToDoScheduleView {
  enum AlarmLabel {}
  enum RepetitionLabel {}
}

extension EditToDoSceneTheme.Constant.StringLiteral.ToDoScheduleView.AlarmLabel {
  static let text = "알림"
}

extension EditToDoSceneTheme.Constant.StringLiteral.ToDoScheduleView.RepetitionLabel {
  static let text = "반복"
}
