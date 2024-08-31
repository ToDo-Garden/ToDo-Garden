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
}
