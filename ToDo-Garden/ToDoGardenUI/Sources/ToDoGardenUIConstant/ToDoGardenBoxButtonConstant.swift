//
//  ToDoGardenBoxButtonConstant.swift
//
//
//  Created by SONG on 3/7/24.
//

import Foundation

public enum ToDoGardenBoxButtonConstant {
  public enum Alpha {
    case highlighted
    case normal
    
    public var value: CGFloat {
      switch self {
      case ToDoGardenBoxButtonConstant.Alpha.highlighted:
        return 0.7
      case ToDoGardenBoxButtonConstant.Alpha.normal:
        return 1.0
      }
    }
  }
  
  public enum Size {
    case primary
    case secondary
    case tertiary
    
    public var width: CGFloat {
      switch self {
      case ToDoGardenBoxButtonConstant.Size.primary:
        return 302.0
      case ToDoGardenBoxButtonConstant.Size.secondary:
        return 287.0
      case ToDoGardenBoxButtonConstant.Size.tertiary:
        return 288.0
      }
    }
    
    public var height: CGFloat {
      switch self {
      case ToDoGardenBoxButtonConstant.Size.primary:
        return 49.0
      case ToDoGardenBoxButtonConstant.Size.secondary:
        return 55.0
      case ToDoGardenBoxButtonConstant.Size.tertiary:
        return 49.0
      }
    }
    
    public var cornerRadius: CGFloat {
      switch self {
      case ToDoGardenBoxButtonConstant.Size.primary:
        return 49.0 / 2
      case ToDoGardenBoxButtonConstant.Size.secondary:
        return 55.0 / 2
      case ToDoGardenBoxButtonConstant.Size.tertiary:
        return 49.0 / 2
      }
    }
  }
}
