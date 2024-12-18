//
//  Constant+ToDoGroupSectionHeaderView.swift
//  ToDoGardenUI
//
//  Created by Noah on 12/17/24.
//

import Foundation

import struct UIKit.UIGeometry.UIEdgeInsets

extension Constant.ToDoGroupSectionHeaderView {
  public enum Layout { }
}

extension Constant.ToDoGroupSectionHeaderView.Layout {
  public static let progressViewLineWidth: CGFloat = 4
  public static let progressViewSize: CGSize = CGSize(width: 23, height: 23)
  public static let timerImageViewSize: CGSize = CGSize(width: 24, height: 24)
  public static let progressViewSpacing: CGFloat = 6
  public static let hStackLayoutMargins: UIEdgeInsets = UIEdgeInsets(
    top: CGFloat.zero,
    left: 31,
    bottom: CGFloat.zero,
    right: 40
  )
}
