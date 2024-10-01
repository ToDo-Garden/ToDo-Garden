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
    static let leftBarButtonTitleSave: String = "저장"
    static let addGroupFooterButtonTitle: String = "그룹 추가하기"
  }
  
  enum Layout {
    enum BarButton {
      static let width: CGFloat = 30.0
      static let height: CGFloat = 20.0
    }
    enum Cell {
      static let height: CGFloat = 45.0
    }
    enum FooterView {
      static let height: CGFloat = 50.0
      static let buttonLeading: CGFloat = 15.0
      static let buttonHeight: CGFloat = 44.0
    }
    enum TableView {
      static let sideMargin: CGFloat = 5.0
      static let top: CGFloat = 25.0
    }
  }
  
  enum Animation {
    static let duration = 0.3
  }
}
