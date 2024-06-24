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
    static var title = "ToDo 편집"
  }

  enum EditToDoViewController {
    static var title = "완료"
  }

  enum EditToDoView {
    enum GroupLabel {
      static var text = "그룹"
    }

    enum DeleteToDoButton {
      static var title = "삭제하기"
    }
  }

  enum ToDoScheduleView {
    enum AlarmLabel {
      static var text = "알림"
    }

    enum RepetitionLabel {
      static var text = "반복"
    }
  }
}
