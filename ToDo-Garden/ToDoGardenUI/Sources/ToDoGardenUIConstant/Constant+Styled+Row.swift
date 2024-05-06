import struct Foundation.CGFloat
import struct Foundation.CGSize
import struct UIKit.NSDirectionalEdgeInsets

public extension Constant.Styled {
  enum Row { 
    public enum ToDoList {}
    public enum Profile {}
    public enum ListPrimary {}
  }
}

public extension Constant.Styled.Row.ToDoList {
  static let stackEdgeInsets = NSDirectionalEdgeInsets(top: 12, leading: 41, bottom: 12, trailing: 0)
  static let stackSpacing = CGFloat(4)
  static let buttonSize = CGSize(width: 18, height: 18)
  // TODO: 디자이너분한테 문의 한 상태
  static let textFieldWidth = CGFloat(200)
}

public extension Constant.Styled.Row.Profile {
  static let profileSize = CGSize(width: 55, height: 55)
  static let accessorySize = CGSize(width: 24, height: 24)
  static let stackSpacing = CGFloat(15)
  static let stackEdgeInsets = NSDirectionalEdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 36)
  static let conditionSpacing = CGFloat(3)
}

public extension Constant.Styled.Row.ListPrimary {
  static let stackEdgeInsets = NSDirectionalEdgeInsets(top: 0, leading: 14, bottom: 0, trailing: 14)
  static let colorViewCornerRadius = CGFloat(12)
  static let colorViewSize = CGSize(width: 24, height: 24)
}
