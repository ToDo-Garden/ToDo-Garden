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
    static let introductionNotExisted = "소개글을 입력해주세요"
    static let userIntroductionPlaceholderText = "소개글을 입력해주세요"

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

  enum SettingAppAlert {
    static let message = "프로필 이미지를 변경하려면\n사진 접근 권한을 허용해야 합니다."
    static let leftActionTitle = "취소"
    static let rightActionTitle = "설정으로 이동"
  }

  static let title = "프로필"
}
