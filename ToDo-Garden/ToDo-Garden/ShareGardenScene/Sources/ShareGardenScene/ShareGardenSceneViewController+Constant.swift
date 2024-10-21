//
//  ShareGardenSceneViewController+Constant.swift
//
//
//  Created by Noah on 7/5/24.
//

import Foundation
import struct UIKit.NSDirectionalEdgeInsets

extension ShareGardenSceneViewController {
  enum Constant {
    enum StringLiteral { }
    enum Layout { }
  }
}

// MARK: - String literal

extension ShareGardenSceneViewController.Constant.StringLiteral {
  enum MyGardenSectionHeaderView {
    static let title = "나의 가든"
  }
  
  enum ProfileInfoView {
    static let nicknamePlaceholder = "                      "
    static let descriptionPlaceholder = " "
  }
  
  enum FriendsGardenSectionHeaderView {
    static let title = "친구의 가든"
    static let rightActionButtonTitle = "편집"
  }
}

// MARK: - Layout

extension ShareGardenSceneViewController.Constant.Layout {
  static let myGardenViewTopInsetRatio: CGFloat = 19 / 812
  
  enum SectionHeaderView {
    static let spacingRatio: CGFloat = 100 / 323
  }
  
  enum FriendsGardenListViewCell {
    static let contentViewBottomInsetWhenSelected: CGFloat = 15
    static let gardenViewTopInsetWhenSelected: CGFloat = 9
  }
  
  enum FriendsGardenListViewLoadingCell {
    static let profilePlaceholderWidth: CGFloat = 36.0
    static let profilePlaceholderHeight: CGFloat = 36.0
    static let profilePlaceholderCornerRadius: CGFloat = 18.0
    static let nicknamePlaceholderHeight: CGFloat = 16.0
    static let nicknamePlaceholderCornerRadius: CGFloat = 8.0
    static let placeholderContainerDirectionalMargins: NSDirectionalEdgeInsets = NSDirectionalEdgeInsets(
      top: 6,
      leading: 25,
      bottom: 6,
      trailing: 25
    )
  }
  
  enum FriendsGardenListView {
    static let gradientLayerHeight: CGFloat = 25.0
  }
  
  enum FriendsGardenInfoView {
    static let contentSize: CGSize = CGSize(width: 375, height: 137)
    static let gardenViewtopInset: CGFloat = 3.0
  }
  
  enum FriendsGardenProfileInfoView {
    static let defaultInset: NSDirectionalEdgeInsets = NSDirectionalEdgeInsets(
      top: 6,
      leading: 25,
      bottom: 6,
      trailing: 25
    )
    
    static let editingInset: NSDirectionalEdgeInsets = NSDirectionalEdgeInsets(
      top: 6,
      leading: 11,
      bottom: 6,
      trailing: 25
    )
  }
  
  enum MyGardenView {
    static let contentHeight: CGFloat = 270
    static let shareButtonSize: CGSize = CGSize(width: 25, height: 25)
    static let contentViewSpacing: CGFloat = 14.0
  }
  
  enum FriendsGardenView {
    static let editButtonWidth: CGFloat = 35.0
    static let editButtonHeight: CGFloat = 35.0
    static let stackViewSpacing: CGFloat = 14.0
    static let sectionHeaderViewLeftInsetRatio: CGFloat = 28.0 / 375.0
    static let sectionHeaderViewRightInsetRatio: CGFloat = 15.0 / 375.0
    static let searchGardenButtonTopInset: CGFloat = 8
    static let searchGardenButtonHeight: CGFloat = 24.0
    static let searchGardenButtonHorizontalInsetRatio: CGFloat = 19.0 / 375.0
    static let numberOfPlaceholderCells: Int = 3
    static let retryRequestViewTopSpacingRatio: CGFloat = 72 / 812
    static let friendsGardenListViewMinimumHeight: CGFloat = 278
  }
}
