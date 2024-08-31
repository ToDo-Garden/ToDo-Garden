//
//  ShareGardenSceneViewController+Constant.swift
//
//
//  Created by Noah on 7/5/24.
//

import Foundation

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
  enum SectionHeaderView {
    static let spacingRatio: CGFloat = 100 / 323
  }
  
  enum FriendsGardenListViewCell {
    static let contentViewBottomInsetWhenSelected: CGFloat = 15
    static let gardenViewTopInsetWhenSelected: CGFloat = 9
  }
  
  enum FriendsGardenListView {
    static let fullWidthRatio: CGFloat = 1.0
    static let estimatedItemHeight: CGFloat = 48.0
    static let gradientLayerHeight: CGFloat = 25.0
  }
  
  enum FriendsGardenView {
    static let editButtonWidth: CGFloat = 35.0
    static let editButtonHeight: CGFloat = 35.0
    static let stackViewSpacing = 15.0
    static let sectionHeaderViewLeftInsetRatio: CGFloat = 28.0 / 375.0
    static let sectionHeaderViewRightInsetRatio: CGFloat = 22.0 / 375.0
    static let searchGardenButtonHorizontalInsetRatio: CGFloat = 19.0 / 375.0
  }
}
