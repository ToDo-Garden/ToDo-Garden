//
//  Constant+LongestRecordView.swift
//
//
//  Created by SONG on 11/12/24.
//

import Foundation

extension Constant.LongestRecordView {
  public enum Layout {
    public static let cornerRadius: CGFloat = 10.0
    public static let borderWidth: CGFloat = 1.0
  }
  
  public enum StringLiteral {
    public static let pomo = "뽀모"
    public static let day = "일"
  }

  public enum TitleLabel {
    public enum Layout {
      public static let top: CGFloat = 10.0
      public static let leading: CGFloat = 12.0
    }
  }
  
  public enum InfoButton {
    public enum Layout {
      public static let length: CGFloat = 12.0
      public static let leading: CGFloat = 3.0
    }
  }
  
  public enum LabelStackView {
    public enum Layout {
      public static let commonMargin: CGFloat = -12.0
    }
  }
  
  public enum LeafSymbol {
    public enum Layout {
      public static let leading: CGFloat = 15.0
      public static let bottom: CGFloat = -21.0
      public static let width: CGFloat = 30.0
      public static let height: CGFloat = 38.0
    }
  }
}
