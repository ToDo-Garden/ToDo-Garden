//
//  UserInfoSceneViewController+Constant.swift
//
//
//  Created by Wood on 9/2/24.
//

import Foundation

extension UserInfoSceneViewController {
  enum Constant {}
}

extension UserInfoSceneViewController.Constant {
  enum ProfileInfoView {
    static let topMargin: CGFloat = 10
    static let size = CGSize(width: 86, height: 114)
  }

  enum ProfileImageView {
    static let size = CGSize(width: 86, height: 86)
  }

  enum EditProfileImageButton {
    static let topMargin: CGFloat = 3
  }

  enum UserInfoCollectionView {
    static let topMargin: CGFloat = 9
    static let leadingMargin: CGFloat = 28
    static let trailingMargin: CGFloat = 28
    static let height: CGFloat = 236
  }

  enum SectionHeaderView {
    static let leadingMargin: CGFloat = 11
  }

  enum ManageAccountView {
    static let topMargin: CGFloat = 35
    static let height: CGFloat = 70
  }

  enum LogOutButton {
    enum Layer {
      static let cornerRadius: CGFloat = 10
    }

    static let height: CGFloat = 40
    static let titleLeadingMargin: CGFloat = 21
  }

  enum WithdrawMembershipButton {
    static let topMargin: CGFloat = 8
  }
}
