//
//  GuideModels.swift
//  GuideScene
//
//  Created by Cloud on 8/12/24.
//  Copyright (c) 2024 ToDoGarden. All rights reserved.

import Foundation

public enum Guide {
  
  public enum GuideState: Sendable {
    case todoCreate
    case groupManagement
    case todoEdit
    case shareTab
  }
  
  // MARK: Use cases
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
