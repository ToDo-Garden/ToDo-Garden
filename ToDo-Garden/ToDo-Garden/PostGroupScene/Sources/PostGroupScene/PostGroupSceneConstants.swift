//
//  PostGroupSceneConstants.swift
//
//
//  Created by SONG on 7/21/24.
//

import Foundation

enum Constant {
  enum BottomSheet {
    static let multiplier: CGFloat = 0.41
  }
}

extension Constant.BottomSheet {
  enum StringLiteral {
    static let title: String = "컬러지정"
    static let cancel: String = "취소"
  }
  
  enum DimmedView {
    static let normalAlpha: CGFloat = 0.5
    static let presentingAlpha: CGFloat = 1.0
  }
  
  enum BottomSheetView {
    static let cornerRadius: CGFloat = 16.0
  }
  
  enum GrabberView {
    static let cornerRadius: CGFloat = 2.5
    static let topMargin: CGFloat = 8.0
    static let width: CGFloat = 36.0
    static let height: CGFloat = 5.0
  }
  
  enum ColorPickerList {
    static let multiplier: CGFloat = 3.03
  }
  
  enum BottomButton {
    static let multiplier: CGFloat = -10.0
  }
  
  enum NavigationBar {
    static let multiplier: CGFloat = 11.64
    static let height: CGFloat = 44.0
    static let trailingMargin: CGFloat = -16.0
  }
  
  enum Animation {
    static let duration: CGFloat = 0.3
  }
}
