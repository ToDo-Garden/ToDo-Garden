import Foundation

extension EditToDoViewController {
  enum Constant {}
}

extension EditToDoViewController.Constant {
  enum Layout {}
}

extension EditToDoViewController.Constant.Layout {
  enum EditToDoView {}
  enum EditToDoScheduleView {}

  enum CompleteEditingButton {
    static let bottomMargin: CGFloat = 13
  }

  enum EditModeSegmentedControl {
    static let topMargin: CGFloat = 10
    static let leadingMargin: CGFloat = 12
    static let trailingMargin: CGFloat = 13
    static let height: CGFloat = 49
  }

  enum EditModeScrollView {
    static let topMargin: CGFloat = 30
    static let leadingMargin: CGFloat = 12
    static let trailingMargin: CGFloat = 19
    static let bottomMargin: CGFloat = 150
  }
}

extension EditToDoViewController.Constant.Layout.EditToDoView {
  enum ToDoNameTextInputView {
    static let topMargin: CGFloat = 16.5
    static let leadingMargin: CGFloat = 15.5
    static let trailingMargin: CGFloat = 15.5
    static let height: CGFloat = 23.5
  }

  enum GroupLabel {
    static let topMargin: CGFloat = 61
    static let leadingMargin: CGFloat = 19
  }

  enum GroupSelectionView {
    static let topMargin: CGFloat = 18
  }

  enum DeleteToDoButton {
    static let titleLeadingMargin: CGFloat = 14
    static let cornerRadius: CGFloat = 10
    static let topMargin: CGFloat = 59
    static let leadingMargin: CGFloat = 13
    static let trailingMargin: CGFloat = 6
    static let height: CGFloat = 44
  }
}

extension EditToDoViewController.Constant.Layout.EditToDoScheduleView {
  enum EditToDoAlarmView {}
  enum EditToDoRepetitionView {}
}

extension EditToDoViewController.Constant.Layout.EditToDoScheduleView.EditToDoAlarmView {
  enum AlarmLabel {
    static let leadingMargin: CGFloat = 4
  }

  enum AlarmTimeSettingView {
    static let topMargin: CGFloat = 7
    static let leadingMargin: CGFloat = 18
    static let trailingMargin: CGFloat = 11
    static let height: CGFloat = 53
  }

  static let topMargin: CGFloat = 10
  static let height: CGFloat = 92
}

extension EditToDoViewController.Constant.Layout.EditToDoScheduleView.EditToDoRepetitionView {
  enum RepetitionLabel {
    static let leadingMargin: CGFloat = 3
  }

  enum RepeatOnlyTodayView {
    static let topMargin: CGFloat = 11
    static let leadingMargin: CGFloat = 18
    static let trailingMargin: CGFloat = 11
  }

  enum RepeatOtherDaysView {
    static let topMargin: CGFloat = 11
  }

  static let topMargin: CGFloat = 49
  static let height: CGFloat = 231
}
