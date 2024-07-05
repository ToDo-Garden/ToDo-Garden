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
  enum HeaderView {
    static let title = "나의 가든"
  }
}

// MARK: - Layout

extension ShareGardenSceneViewController.Constant.Layout {
  enum HeaderView {
    static let spacingRatio: CGFloat = 194 / 323
  }
}
