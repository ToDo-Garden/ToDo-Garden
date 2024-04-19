//
//  Constant+SearchGardenButton.swift
//
//
//  Created by Wood on 4/19/24.
//

import Foundation

extension Constant.SearchGardenButton {
  public enum Layout {}
}

extension Constant.SearchGardenButton.Layout {
  public enum ImageView {}
}

extension Constant.SearchGardenButton.Layout {
  public static let cornerRadius: CGFloat = 12
}

extension Constant.SearchGardenButton.Layout.ImageView {
  public static let trailingConstraint: CGFloat = -12.5
}
