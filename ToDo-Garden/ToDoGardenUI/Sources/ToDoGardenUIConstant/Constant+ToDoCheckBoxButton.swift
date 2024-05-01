//
//  Constant+ToDoCheckBoxButton.swift
//
//
//  Created by Wood on 5/1/24.
//

import Foundation

extension Constant.ToDoCheckBoxButton {
  public enum Layout { }
  public enum Action { }
  public enum Animation { }
}

extension Constant.ToDoCheckBoxButton.Layout {
  public static let borderWidth: CGFloat = 0.6
  public static let cornerRadius: CGFloat = 3.0
}

extension Constant.ToDoCheckBoxButton.Action {
  public static let impactIntesity: CGFloat = 0.6
}

extension Constant.ToDoCheckBoxButton.Animation {
  public static let lineWidth: CGFloat = 1.0
  public static let keyPath: String = "strokeEnd"
  public static let duration: CGFloat = 0.4
  public static let fromValue: CGFloat = 0.0
  public static let toValue: CGFloat = 1.0
}
