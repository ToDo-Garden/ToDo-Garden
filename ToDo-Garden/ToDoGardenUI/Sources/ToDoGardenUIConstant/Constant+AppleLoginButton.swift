//
//  Constant+AppleLoginButton.swift
//
//
//  Created by SONG on 9/9/24.
//

import Foundation

extension Constant.AppleLoginButton {
  public static let width: CGFloat = 325.0
  public static let height: CGFloat = 44.0
  public static let cornerRadius: CGFloat = 10.0
  public static let fontSize: CGFloat = 19.0
  
  public enum ContentInsets {
    public static let vertical: CGFloat = 10.0
    public static let leading: CGFloat = 59.0
    public static let trailing: CGFloat = 79.0
  }
  
  public enum AppleLogo {
    public static let imagePadding: CGFloat = 16.0
  }
  
  public enum StringLiteral {
    public static let title: String = "Apple로 계속하기"
  }
}
