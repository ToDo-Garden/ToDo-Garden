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
    
    enum Cell {
      static let height: CGFloat = 45.0
      static let leadingNormal: CGFloat = 20.0
      static let leadingEdit: CGFloat = -5.0
    }
    enum FooterView {
      static let height: CGFloat = 60.0
      static let leadingNormal: CGFloat = 5.0
      static let leadingEdit: CGFloat = 30.0
    }
    enum TableView {
      static let leading: CGFloat = 20.0
      static let top: CGFloat = 25.0
    }
  }
  
  enum Animation {
    static let duration = 0.3
  }
}
