//
//  Constant+LightRoundRectButton.swift
//
//
//  Created by SONG on 5/17/24.
//

import UIKit.UIGeometry

extension Constant.LightRoundRectButton {
  public enum Layout {
    public static let contentsInsetsPrimary = NSDirectionalEdgeInsets(
      top: 4,
      leading: 10,
      bottom: 4,
      trailing: 10
    )
    public static let contentsInsetsSecondary = NSDirectionalEdgeInsets(
      top: 3,
      leading: 5,
      bottom: 4,
      trailing: 5
    )
  }
  
  public enum StringLiteral {
    public static let everyday = "매일"
    public static let timeSelection = "시간지정"
    public static let start = "시작"
    public static let end = "종료"
  }
}
