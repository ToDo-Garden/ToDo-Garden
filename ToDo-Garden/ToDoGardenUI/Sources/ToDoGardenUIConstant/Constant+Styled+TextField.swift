import struct Foundation.CGFloat

public extension Constant.Styled {
  enum TextField { }
}

public extension Constant.Styled.TextField {
  enum Primary { }
  enum GroupEdit { }
}

public extension Constant.Styled.TextField.Primary {
  enum Standard { }
}

public extension Constant.Styled.TextField.Primary.Standard {
  static let cornerRadius = CGFloat(10)
  static let imageLeading = CGFloat(7)
  static let imageTrailing = CGFloat(4)
}

public extension Constant.Styled.TextField.GroupEdit {
  static let bottomLineHeight = CGFloat(1)
  static let bottomLinePadding = CGFloat(4.5)
}

public extension Constant.Styled.TextField.GroupEdit {
  enum BottomLineAnimation { }
}

public extension Constant.Styled.TextField.GroupEdit.BottomLineAnimation {
  static let duration: CGFloat = 0.2
}
