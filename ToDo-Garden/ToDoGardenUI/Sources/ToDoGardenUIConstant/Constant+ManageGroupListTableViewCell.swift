//
//  Constant+ManageGroupListTableViewCell.swift
//
//
//  Created by SONG on 6/23/24.
//

import Foundation

extension Constant.ManageGroupListTableViewCell {
  public enum CommonSize {
    public static let size: CGSize = CGSize(width: 24.0, height: 24.0)
  }
  
  public enum ProgressCircle {
    public static let lineWidth: CGFloat = 4.0
    public static let leading: CGFloat = 15.0
  }
  
  public enum GroupNameButton {
    public static let cornerRadius: CGFloat = 13
    public static let leading: CGFloat = 7.0
    public static let verticalInset: CGFloat = 5.0
    public static let horizontalInset: CGFloat = 11.0
    public static let height: CGFloat = 26.0
    public static let widthMultiplier: CGFloat = 0.7
  }
  
  public enum RightImageView {
    public static let trailingPrimary: CGFloat = 9.0
    public static let trailingSecondary: CGFloat = 40.0
  }
}
