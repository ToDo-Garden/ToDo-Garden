import Foundation

enum EditToDoSceneTheme {
  enum Constant {}
}

extension EditToDoSceneTheme.Constant {
  enum Layout {}
  enum StringLiteral {}
}

extension EditToDoSceneTheme.Constant.Layout {
  enum CompleteEditingButton {
    static let bottomMargin: CGFloat = 13
  }

  enum EditModeSegmentedControl {
    static let topMargin: CGFloat = 10
    static let leadingMargin: CGFloat = 12
    static let trailingMargin: CGFloat = 13
    static let height: CGFloat = 49
  }

  enum ToDoScheduleView {
    enum AlarmTimeSettingView {
      static let topMargin: CGFloat = 7
      static let height: CGFloat = 53
    }

    enum RepetitionLabel {
      static let topMargin: CGFloat = 50
      static let leadingMargin: CGFloat = 3
    }

    enum RepeatOnlyTodayButton {
      static let topMargin: CGFloat = 10
    }

    enum RepeatOtherDaysView {
      static let topMargin: CGFloat = 11
    }

    static let topMargin: CGFloat = 40
    static let leadingMargin: CGFloat = 30
    static let traillingMargin: CGFloat = 30
    static let bottomMargin: CGFloat = 150
  }
}

extension EditToDoSceneTheme.Constant.StringLiteral {
  enum CompleteEditingButton {
    static let title = "ToDo 편집"
  }

  enum EditToDoViewController {
    static let title = "완료"
  }

  enum ToDoScheduleView {
    enum AlarmLabel {
      static let text = "알림"
    }

    enum RepetitionLabel {
      static let text = "반복"
    }
  }
}
