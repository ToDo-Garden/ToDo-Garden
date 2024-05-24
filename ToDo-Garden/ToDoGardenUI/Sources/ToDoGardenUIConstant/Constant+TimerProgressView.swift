//
//  Constant+TimerProgressView.swift
//
//
//  Created by Noah on 5/24/24.
//

import Foundation

extension Constant.TimerProgressView {
  public enum Layout { }
  public enum StringLiteral { }
}

// MARK: - Layout

extension Constant.TimerProgressView.Layout {
  public enum Dot { }
}

extension Constant.TimerProgressView.Layout.Dot {
  public static let width: CGFloat  = 24
  public static let height: CGFloat = 24
}

// MARK: - StringLiteral

extension Constant.TimerProgressView.StringLiteral {
  public enum Dot { }
}

extension Constant.TimerProgressView.StringLiteral.Dot {
  public enum Animation { }
}

extension Constant.TimerProgressView.StringLiteral.Dot.Animation {
  public static let keyPath: String = "position"
}
