//
//  DynamicProperty.swift
//  TDUtility
//
//  Created by Noah on 7/15/24.
//

import Foundation

@propertyWrapper
public final class DynamicProperty<Value> {
  private var value: Value
  // TODO: changeHandler가 여러개가 되어야 할 경우 관리 자료구조 추가 혹은 관리 비용이 커질 경우 Combine등 다른 프레임워크 고려
  private var changeHandler: ((Value) -> Void)?
  
  public var wrappedValue: Value {
    get { self.value }
    set {
      self.value = newValue
      self.changeHandler?(newValue)
    }
  }
  
  // TODO: 동시성 환경에서 사용될 경우 @Sendable attribute 명시
  public var projectedValue: (@escaping (Value) -> Void) -> Void {
    return { [weak self] newHandler in
      guard let self else { return }
      
      self.changeHandler = newHandler
      newHandler(self.value)
    }
  }
  
  public init(wrappedValue: Value) {
    self.value = wrappedValue
  }
}
