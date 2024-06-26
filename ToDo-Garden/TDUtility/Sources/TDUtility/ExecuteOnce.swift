//
//  ExecuteOnce.swift
//
//
//  Created by Noah on 6/25/24.
//

import Foundation

@propertyWrapper
public struct ExecuteOnce {
  private var hasExecute = false
  private var action: (() -> Void)?
  
  public init() { }
  
  public var wrappedValue: (() -> Void)? {
    mutating get {
      guard self.hasExecute == false
      else { return nil }
      
      return self.action
    }
    set {
      guard self.hasExecute == false
      else { return }
      
      self.action = newValue
      self.hasExecute = true
      self.action?()
    }
  }
}
