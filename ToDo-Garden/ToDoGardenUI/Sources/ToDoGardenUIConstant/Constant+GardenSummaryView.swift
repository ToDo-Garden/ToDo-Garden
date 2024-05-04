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
