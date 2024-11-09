//
//  Constant+BubbleLabel.swift
//
//
//  Created by SONG on 11/9/24.
//

import Foundation

extension Constant.BubbleLabel {
  public enum BubbleTextBox { }
  public enum TailView { }
  
  public static let commonMargin: CGFloat = 10.0
  public static let tailPositionMargin: CGFloat = 35.0
}

extension Constant.BubbleLabel.BubbleTextBox {
  public static let commonMargin: CGFloat = 15.0
  public static let fontSize: CGFloat = 14.0
  public static let iconLength: CGFloat = 13.0
  public static let cancelButtonLength = 18.0
  public static let singleSpace: String = " "
}

extension Constant.BubbleLabel.TailView {
  public static let height: CGFloat = 12.0
  public static let width: CGFloat = 15.0
}
