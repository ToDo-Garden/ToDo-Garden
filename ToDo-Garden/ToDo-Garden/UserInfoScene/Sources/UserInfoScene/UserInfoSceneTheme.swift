//
//  UserInfoSceneTheme.swift
//
//
//  Created by Wood on 9/2/24.
//

import UIKit

import TDUtility
import ToDoGardenUIResource

enum UserInfoSceneTheme {
  @DynamicUIProperty static var mainColor = UIColor.toDoGardenGreenDark
}

extension UserInfoSceneTheme {
  enum StringLiteral {}
}

extension UserInfoSceneTheme.StringLiteral {
  enum EditProfileImageButton {
    static let title = "이미지 변경"
  }

  static let title = "프로필"
}
