//
//  Constant+PeriodSegmentedControl.swift
//
//
//  Created by SONG on 4/5/24.
//

import Foundation

extension Constant.PeriodSegmentedControl {
  public enum Layout {}
  public enum Content {}
}

extension Constant.PeriodSegmentedControl.Layout {
  public static let innerPadding: CGFloat = 5.0
  public static let segmentWidth: CGFloat = 24.0
  public static let firstSegmentCenterXPosition: CGFloat = 17.0
  public static let height: CGFloat = 26.0
  public static let indicatorViewWidth: CGFloat = 23.0
}

extension Constant.PeriodSegmentedControl.Content {
  public static let defaultSegments: [String] = ["일", "주", "월"]
}
