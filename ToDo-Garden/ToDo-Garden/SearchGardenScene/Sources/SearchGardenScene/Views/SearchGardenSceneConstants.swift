//
//  SearchGardenSceneConstants.swift
//
//
//  Created by SONG on 11/26/24.
//

import Foundation

enum Constant {
  enum SearchGardenView {
    public static let commonMargin: CGFloat = 18.0
    public static let textfieldHeight: CGFloat = 32.0
    public static let cellHeight: CGFloat = 59.0
    public static let defaultUserNickName = "UserNickName"
    public static let defaultUserIntroduction = "UserIntroduction"
  }
  
  enum NavigationBar {
    public static let height: CGFloat = 75.0
    public static let title = "가든찾기"
    public static let rightButtonTitle = "완료"
  }
  
  enum AddGardenView {
    public static let height: CGFloat = 390.0
    public static let width: CGFloat = 320.0
    public static let duration = 0.3
  }
  
  enum ToastView {
    public static let successMessage = "가든 추가 성공!"
    public static let failMessage = "가든 추가 실패!"
  }
}
