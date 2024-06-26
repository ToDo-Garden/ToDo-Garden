//
//  TimerSceneModels.swift
//  
//
//  Created by Cloud on 6/17/24.
//  Copyright (c) 2024 ToDoGarden. All rights reserved.

import Foundation

public enum TimerScene {
  public enum CircularProgressRange {
    case oneThird
    case twoThirds
    case whole
    
    public init(_ percent: Double) {
      switch percent {
      case 0.0..<0.3:
        self = .oneThird
      case 0.3..<0.6:
        self = .twoThirds
      default:
        self = .whole
      }
    }
  }
  
  public enum Something {
    public struct Request {
      public init() { }
    }
    public struct Response {
      public init() { }
    }
    public struct ViewModel {
      public init() { }
    }
  }
}
