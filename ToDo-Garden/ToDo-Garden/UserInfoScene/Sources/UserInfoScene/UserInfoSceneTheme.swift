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

  enum UserInfoCollectionView {
    enum Section {
      static let profileSetting = "프로필 설정"
      static let accountSetting = "계정 설정"
    }

    enum Item {
      static let nickName = "닉네임"
      static let introduction = "소개"
      static let id = "아이디"
      static let email = "이메일"
    }
  }

  enum LogOutButton {
    static let title = "로그아웃"
  }

  enum WithdrawMembershipButton {
    static let title = "회원 탈퇴"
  }

  static let title = "프로필"
}
