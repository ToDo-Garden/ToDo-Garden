//
//  Constant+ToDoCheckBoxButton.swift
//
//
//  Created by Wood on 5/1/24.
//

import Foundation

extension Constant.ToDoCheckBoxButton {
  public enum Size { }
  public enum Layout { }
  public enum Action { }
  public enum Animation { }
}

extension Constant.ToDoCheckBoxButton.Size {
  public static let priamry = CGSize(width: 18, height: 18)
}

extension Constant.ToDoCheckBoxButton.Layout {
  public static let borderWidth: CGFloat = 0.6
  public static let cornerRadius: CGFloat = 3.0
  public static let lineWidth: CGFloat = 1.0
}

extension Constant.ToDoCheckBoxButton.Action {
  public static let impactIntesity: CGFloat = 0.6
}

extension Constant.ToDoCheckBoxButton.Animation {
  public static let keyPath: String = "strokeEnd"
  public static let duration: CGFloat = 0.4
  public static let fromValue: CGFloat = 0.0
  public static let toValue: CGFloat = 1.0
}

extension Constant.ToDoCheckBoxButton.Animation {
  public enum Path {
    public enum StartPoint {}
    public enum MiddlePoint {}
    public enum EndPoint {}
  }
}

public extension Constant.ToDoCheckBoxButton.Animation.Path.StartPoint {
  static let offsetX: CGFloat = 0.29
  static let offsetY: CGFloat = 0.43
}

public extension Constant.ToDoCheckBoxButton.Animation.Path.MiddlePoint {
  static let offsetX: CGFloat = 0.18
  static let offsetY: CGFloat = 0.29
}

public extension Constant.ToDoCheckBoxButton.Animation.Path.EndPoint {
  static let offsetX: CGFloat = 0.25
  static let offsetY: CGFloat = 0.43
}
