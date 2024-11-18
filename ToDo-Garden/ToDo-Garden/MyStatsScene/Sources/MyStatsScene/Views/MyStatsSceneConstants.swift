//
//  File.swift
//  
//
//  Created by SONG on 11/18/24.
//

import Foundation

enum Constant {
  enum Layout {
    static let topMargin: CGFloat = 15.0
    static let horizontalMargin: CGFloat = 10.0
    static let gardenViewHeight: CGFloat = 120.0
    static let longestRecordsViewHeight: CGFloat = 125.0
    static let summaryViewViewHeight: CGFloat = 150.0
  }
  
  enum StringLiteral {
    static let suffix: String = " 님,"
    static let nextLine: String = "\n"
    static let keepingDesctription: String = "일 연속으로 기록 유지중이에요"
  }
  
  enum LongestRecordStackView {
    enum Layout {
      static let topMargin: CGFloat = 5.0
      static let spacing: CGFloat = 10.0
      static let leading: CGFloat = -25
    }
    
    enum StringLiteral {
      static let leftViewTitle: String = "최장 집중 기록"
      static let rightViewTitle: String = "최장 연속 기록"
      static let bubbleLabelTitle: String = "집중시간+휴식시간=1뽀모"
    }
    
    enum Animation {
      static let duration: CGFloat = 0.3
    }
  }
  
  enum MyStatsPeriodicSummaryView {
    enum Layout {
      static let horizontalMargin: CGFloat = 5.0
      static let topMargin: CGFloat = 17.0
      static let summaryViewHeight: CGFloat = 103.0
    }
    
    enum StringLiteral {
      static let leftViewTitle: String = "평균 집중 시간"
      static let leftViewDesc: String = "0시간 0분"
      static let rightViewTitle: String = "평균 완료 수"
      static let rightViewDesc: String = "0개 목표"
      static let headerTitle: String = "요약"
    }
  }
}
