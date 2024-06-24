import UIKit

import ToDoGardenUIConstant

public final class TextInputView: UIView {
  private let model: Model

  public init(model: Model) {
    self.model = model
    super.init(frame: CGRect.zero)
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension TextInputView {
  public struct Model {
    let inputText: String
    let shrinkScale: CGFloat

    public init(inputText: String, shrinkScale: CGFloat = 0.8) {
      self.inputText = inputText
      self.shrinkScale = shrinkScale
    }

    public static let toDoName = Self(inputText: "할 일")
    public static let groupName = Self(inputText: "그룹명")
    public static let userNickname = Self(inputText: "닉네임")
    public static let userId = Self(inputText: "아이디")
    public static let userDescription = Self(inputText: "소개")
  }
}
