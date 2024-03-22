//
//  Constant+ToDoGardenBoxButton.swift
//
//
//  Created by SONG on 3/21/24.
//

import Foundation

extension Constant.ToDoGardenBoxButton {
  public enum Alpha {
    public static let normal: CGFloat = 1.0
    public static let highlighted: CGFloat = 0.7
  }
  
  public enum Size {
    case primary
    case secondary
    case tertiary
    
    public var width: CGFloat {
      switch self {
      case Constant.ToDoGardenBoxButton.Size.primary:
        return 302.0
      case Constant.ToDoGardenBoxButton.Size.secondary:
        return 287.0
      case Constant.ToDoGardenBoxButton.Size.tertiary:
        return 288.0
      }
    }
    
    public var height: CGFloat {
      switch self {
      case Constant.ToDoGardenBoxButton.Size.primary:
        return 49.0
      case Constant.ToDoGardenBoxButton.Size.secondary:
        return 55.0
      case Constant.ToDoGardenBoxButton.Size.tertiary:
        return 49.0
      }
    }
    
    public var cornerRadius: CGFloat {
      switch self {
      case Constant.ToDoGardenBoxButton.Size.primary:
        return 49.0 / 2
      case Constant.ToDoGardenBoxButton.Size.secondary:
        return 55.0 / 2
      case Constant.ToDoGardenBoxButton.Size.tertiary:
        return 49.0 / 2
      }
    }
  }
}
