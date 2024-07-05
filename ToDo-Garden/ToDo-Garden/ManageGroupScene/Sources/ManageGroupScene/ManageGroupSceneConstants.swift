//
//  ManageGroupSceneConstants.swift
//
//
//  Created by SONG on 7/4/24.
//

import Foundation

enum Constant {
  enum StringLiteral {
    static let navigationbarTitle: String = "그룹관리"
    static let rightBarButtonTitleEdit: String = "편집"
    static let rightBarButtonTitleCancel: String = "취소"
  }
  
  enum Layout {
    static let cellHeight: CGFloat = 45.0
    static let cellLeadingNormal: CGFloat = 20.0
    static let cellLeadingEdit: CGFloat = -5.0
    static let footerHeight: CGFloat = 60.0
    static let footerLeadingNormal: CGFloat = 5.0
    static let footerLeadingEdit: CGFloat = 30.0
    static let tableViewLeading: CGFloat = 20.0
    static let tableViewTop: CGFloat = 25.0
  }
  
  enum AboutAnimation {
    static let duration = 0.3
  }
}
