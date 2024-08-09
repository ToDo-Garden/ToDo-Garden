//
//  UIView+Shimmer.swift
//  ToDoGardenUI
//
//  Created by Noah on 8/9/24.
//

import UIKit

// MARK: - Properties

extension UIView {
  /// Shimmer 애니메이션이 가능한지 여부를 나타내는 변수입니다.
  public var isShimmering: Bool {
    get { self._isShimmering }
    set { self._isShimmering = newValue }
  }
}
