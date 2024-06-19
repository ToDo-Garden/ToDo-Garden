import UIKit.UIColor

import ToDoGardenUIResource

enum EditToDoSceneTheme {
  enum Constant {}
  enum Resource {}
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

  enum EditToDoView {
    static let topMargin: CGFloat = 30
    static let leadingMargin: CGFloat = 12
    static let trailingMargin: CGFloat = 19
    static let bottomMargin: CGFloat = 296
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

extension EditToDoSceneTheme.Resource {
  enum EditToDoViewController {
    static let backgroundColor = UIColor.toDoGardenWhite
  }

  enum ToDoScheduleView {
    enum AlarmLabel {
      static let font = UIFont.pretendardHeadSemiBold
      static let textColor = UIColor.toDoGardenGreenDark
    }

    enum RepetitionLabel {
      static let font = UIFont.pretendardHeadSemiBold
      static let textColor = UIColor.toDoGardenGreenDark
    }
  }
}
