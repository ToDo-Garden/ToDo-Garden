//
//  DynamicProperty.swift
//  TDUtility
//
//  Created by Noah on 7/15/24.
//

import Foundation

/// DynamicProperty는 값의 변화를 관리하기 위해 사용하는 프로퍼티 래퍼입니다.
/// 이 클래스는 값의 변화를 관찰하고 이에 반응해야 하는 상황에서 사용됩니다.
///
/// # 속성
///
/// - wrappedValue: 관리되는 값입니다. 이 값을 설정하면 chnageHandler가 호출됩니다.
/// - projectedValue: changeHandler를 설정할 수 있는 클로저입니다. 이 핸들러는 wrappedValue가 업데이트될 때마다 호출되며, 핸들러가 설정될 때 즉시 현재 값으로 호출됩니다.
///
/// # 사용 예시
///
/// ```swift
/// @DynamicProperty var myProperty: String = "초기값"
///
/// $myProperty { newValue in
///     print("값이 \(newValue)로 변경되었습니다.")
/// }
///
/// myProperty = "Hello, World!"
/// ```
///
/// # 참고 사항
///
/// - 만약 changeHandler가 여러 개여야 한다면, 이를 관리할 자료 구조를 추가하거나, 관리 비용이 커질 경우 Combine 등의 다른 프레임워크를 사용하는 것을 고려하려합니다.
/// - 이 클래스가 동시성 환경에서 사용될 경우, projectedValue 프로퍼티에 @Sendable 속성을 명시해야합니다.
///   - 해당 내용은 TODO 주석에 기재하였습니다.
@propertyWrapper
public final class DynamicUIProperty<Value> {
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
