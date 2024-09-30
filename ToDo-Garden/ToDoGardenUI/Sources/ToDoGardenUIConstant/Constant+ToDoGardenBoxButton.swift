//
//  Constant+ToDoGardenBoxButton.swift
//
//
//  Created by SONG on 3/21/24.
//

import UIKit

extension Constant.ToDoGardenBoxButton {
  public enum Title {
    public static let complete: String = "완료"
    public static let start: String = "시작하기"
    public static let doItLater: String = "나중에 할래요."
    public static let add: String = "추가하기"
  }
  
  public enum Mode {
    case roundRectangle
    case rectangle
  }
  
  public enum Alpha {
    public static let normal: CGFloat = 1.0
    public static let highlighted: CGFloat = 0.7
  }
  
  private enum Size {
    static let primary: CGSize = CGSize(width: 302.0, height: 49.0)
    static let secondary: CGSize = CGSize(width: 287.0, height: 55.0)
    static let tertiary: CGSize = CGSize(width: 288.0, height: 49.0)
    static let small: CGSize = CGSize(width: 230, height: 37.0)
    static let filledHorizontal: CGSize = CGSize(
      width: UIScreen.main.bounds.width,
      height: 49.0
    )
  }
}

extension Constant.ToDoGardenBoxButton {
  public struct DataStore: Equatable {
    public let size: CGSize
    public let mode: Mode
  }
  
  public static let primaryRoundRectButton = DataStore(
    size: Size.primary,
    mode: Mode.roundRectangle
  )
  
  public static let secondaryRoundRectButton = DataStore(
    size: Size.secondary,
    mode: Mode.roundRectangle
  )
  
  public static let tertiaryRoundRectButton = DataStore(
    size: Size.tertiary,
    mode: Mode.roundRectangle
  )
  
  public static let smallRoundRectButton = DataStore(
    size: Size.small,
    mode: Mode.roundRectangle
  )
  
  public static let rectangleButton = DataStore(
    size: Size.filledHorizontal,
    mode: Mode.rectangle
  )
}
