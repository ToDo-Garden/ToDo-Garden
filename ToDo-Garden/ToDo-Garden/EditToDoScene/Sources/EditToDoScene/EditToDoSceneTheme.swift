import UIKit.UIColor

import ToDoGardenUIResource

enum EditToDoSceneTheme {
  static var mainColor = UIColor.toDoGardenGreenDark
}

extension EditToDoSceneTheme {
  enum StringLiteral {}
}

extension EditToDoSceneTheme.StringLiteral {
  enum CompleteEditingButton {
    static let title = "완료"
  }

  enum EditToDoViewController {
    static let title = "ToDo 편집"
  }

  enum EditToDoView {
    enum GroupLabel {
      static let text = "그룹"
    }

    enum DeleteToDoButton {
      static let title = "삭제하기"
    }
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
