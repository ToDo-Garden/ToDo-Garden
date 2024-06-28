import Foundation

extension EditToDoViewController {
  enum Constant {}
}

extension EditToDoViewController.Constant {
  enum Layout {}
}

extension EditToDoViewController.Constant.Layout {
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

  enum EditToDoView {
    enum ToDoNameTextField {
      static let leadingMargin: CGFloat = 15.5
      static let trailingMargin: CGFloat = 15.5
      static let height: CGFloat = 23.5
    }

    enum GroupLabel {
      static let topMargin: CGFloat = 61
      static let leadingMargin: CGFloat = 19
    }

    enum EditGroupRow {
      static let bottomMargin: CGFloat = 18
    }

    enum DeleteToDoButton {
      static let cornerRadius: CGFloat = 10
      static let topMargin: CGFloat = 28
      static let leadingMargin: CGFloat = 13
      static let trailingMargin: CGFloat = 6
      static let height: CGFloat = 44
    }

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
