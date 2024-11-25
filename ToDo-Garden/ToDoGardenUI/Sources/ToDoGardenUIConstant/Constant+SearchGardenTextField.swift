//
//  Constant+SearchGardenTextField.swift
//
//
//  Created by SONG on 11/24/24.
//

import Foundation

extension Constant.SearchGardenTextField {
  public enum Layout {
    public static let cornerRadius: CGFloat = 15.0
    public static let paddingViewRect = CGRect(
      x: 0.0,
      y: 0.0,
      width: 40.0,
      height: 24.0
    )
    
    public static let imageViewRect = CGRect(
      x: 7.0,
      y: 0.0,
      width: 24.0,
      height: 24.0
    )
  }
  
  public enum StringLiteral {
    public static let defaultPlaceHolder = "아이디를 입력해주세요"
  }
}
