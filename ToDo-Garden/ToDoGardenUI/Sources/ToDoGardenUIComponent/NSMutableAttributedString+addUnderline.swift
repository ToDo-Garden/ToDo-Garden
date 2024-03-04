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
  ///   - underlineColor: 추가할 밑줄의 색상입니다.
  ///   - location: 추가할 밑줄의 시작점입니다.
  ///   - length: 추가할 밑줄의 끝점입니다.
  public func addUnderline(
    with underlineColor: UIColor,
    from location: Int,
    to length: Int
  ) -> NSMutableAttributedString? {
    guard self.checkRangeToAddUnderlineIsValid(with: location, and: length) else {
      return nil
    }

    let attributedString = self
    attributedString.addAttributes(
      [
        NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue,
        NSAttributedString.Key.underlineColor: underlineColor
      ],
      range: NSRange(location: location, length: length)
    )

    return attributedString
  }

  private func checkRangeToAddUnderlineIsValid(
    with location: Int,
    and length: Int
  ) -> Bool {
    let minimumLocation = 0
    guard minimumLocation <= location && location < self.length else {
      return false
    }
    
    guard location < length && length <= self.length else {
      return false
    }
    
    return true
  }
}
