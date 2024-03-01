//
//  NSMutableAttributedString+addUnderline.swift
//
//
//  Created by Wood on 3/1/24.
//

import UIKit.UIColor

extension NSMutableAttributedString {
  /// 밑줄을 추가하는 함수입니다.
  /// - Parameters:
  ///   - color: 추가할 밑줄의 색상입니다.
  ///   - location: 추가할 밑줄의 시작점입니다.
  ///   - length: 추가할 밑줄의 끝점입니다.
  public func addUnderline(
    with color: UIColor,
    from location: Int,
    to length: Int
  ) {
    self.addAttributes(
      [
        NSAttributedString.Key.underlineStyle : NSUnderlineStyle.single.rawValue,
        NSAttributedString.Key.underlineColor : color,
      ],
      range: NSRange(location: location, length: length)
    )
  }
}
