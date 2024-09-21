//
//  UserInfoCollectionViewCell.swift
//
//
//  Created by Wood on 9/12/24.
//

import UIKit

import ToDoGardenUIComponent
import UserInfoSceneEntity

protocol UserInfoLoadable: AnyObject {
  func requestDescription(for userInfo: UserInfoScene.UserInfo) async -> String
}

final class UserInfoCollectionViewCell: SettingCollectionViewCell {
  private var requestDescriptionTask: Task<Void, Error>?

  override init(frame: CGRect) {
    super.init(frame: frame)
  }

  func updateUserInfo(_ userInfo: UserInfoScene.UserInfo, with userInfoLoader: UserInfoLoadable?) {
    self.requestDescriptionTask = Task {
      let description = await userInfoLoader?.requestDescription(for: userInfo)
      await MainActor.run {
        self.updateDescription(description)
      }
    }
  }
}
