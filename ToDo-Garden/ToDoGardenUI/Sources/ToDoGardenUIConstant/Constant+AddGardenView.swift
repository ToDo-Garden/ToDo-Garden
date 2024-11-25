//
//  Constant+AddGardenView.swift
//
//
//  Created by SONG on 11/24/24.
//

import Foundation

extension Constant.AddGardenView {
  public enum Layout {
    public static let size: CGSize = CGSize(width: 320.0, height: 390.0)
    public static let cornerRadius: CGFloat = 20.0
    public static let commonMargin: CGFloat = 26.0
    public static let commonHorizontalMargin: CGFloat = 20.0
  }
  
  public enum StringLiteral {
    public static let addButtonTitle: String = "추가하기"
    public static let cancelButtonTitle: String = "취소"
    public static let labelTitle: String = "가든 추가"
  }
  
  public enum GardenView {
    public enum Layout {
      public static let verticalMargin: CGFloat = -40.0
    }
  }
  
  public enum AddButton {
    public enum Layout {
      public static let bottomMargin: CGFloat = -30.0
    }
  }
}
