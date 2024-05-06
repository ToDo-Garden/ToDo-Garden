//
//  Constant+GardenSummaryView.swift
//
//
//  Created by SONG on 5/4/24.
//

import Foundation

extension Constant.GardenSummaryView {
  private enum Content {
    static let averageTimeTitle: String = "평균 집중 시간"
    static let averageCompleteTitle: String = "평균 완료 수"
  }
  
  private enum Layout {
    static let backPlaneWidth: CGFloat = 331.0
    static let backPlaneHeight: CGFloat = 103.0
    static let cornerRadius: CGFloat = 10.0
    static let borderWidth: CGFloat = 1.0
    
    static let titleLeftMargin: CGFloat = 10.0
    static let titleTopMargin: CGFloat = 11.0
    
    static let decriptionRightMargin: CGFloat = -30.0
    static let decriptionBottomMargin: CGFloat = -20.0
    
    static let lineWidth: CGFloat = 2.0
    static let lineHeight: CGFloat = 56.5
  }
}

extension Constant.GardenSummaryView {
  public struct ViewState {
    public let backPlane: BackPlaneState
    public let firstUnitItem: UnitItemState
    public let secondUnitItem: UnitItemState
    public let line: LineState
  }
  
  public struct BackPlaneState {
    public let width: CGFloat
    public let height: CGFloat
    public let cornerRadius: CGFloat
    public let borderWidth: CGFloat
  }
  
  public struct UnitItemState {
    public let title: String
    public let titleLeftMargin: CGFloat
    public let titleTopMargin: CGFloat
    public let decriptionRightMargin: CGFloat
    public let decriptionBottomMargin: CGFloat
  }
  
  public struct LineState {
    public let width: CGFloat
    public let height: CGFloat
  }
}

extension Constant.GardenSummaryView {
  public static let primary = ViewState(
    backPlane:
      BackPlaneState(
        width: Constant.GardenSummaryView.Layout.backPlaneWidth,
        height: Constant.GardenSummaryView.Layout.backPlaneHeight,
        cornerRadius: Constant.GardenSummaryView.Layout.cornerRadius,
        borderWidth: Constant.GardenSummaryView.Layout.borderWidth
      ),
    firstUnitItem: UnitItemState(
      title: Constant.GardenSummaryView.Content.averageTimeTitle,
      titleLeftMargin: Constant.GardenSummaryView.Layout.titleLeftMargin,
      titleTopMargin: Constant.GardenSummaryView.Layout.titleTopMargin,
      decriptionRightMargin: Constant.GardenSummaryView.Layout.decriptionRightMargin,
      decriptionBottomMargin: Constant.GardenSummaryView.Layout.decriptionBottomMargin
    ),
    secondUnitItem: UnitItemState(
      title: Constant.GardenSummaryView.Content.averageCompleteTitle,
      titleLeftMargin: Constant.GardenSummaryView.Layout.titleLeftMargin,
      titleTopMargin: Constant.GardenSummaryView.Layout.titleTopMargin,
      decriptionRightMargin: Constant.GardenSummaryView.Layout.decriptionRightMargin,
      decriptionBottomMargin: Constant.GardenSummaryView.Layout.decriptionBottomMargin
    ),
    line: LineState(
      width: Constant.GardenSummaryView.Layout.lineWidth,
      height: Constant.GardenSummaryView.Layout.lineHeight
    )
  )
}
