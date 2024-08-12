//
//  AssociatedObjects.swift
//  TDUtility
//
//  Created by Noah on 8/9/24.
//

import Foundation

public protocol AssociatedObjects: AnyObject { }

// swiftlint:disable line_length
// Partially copy/pasted from:
// - https://github.com/jameslintaylor/AssociatedObjects/blob/master/AssociatedObjects/AssociatedObjects.swift
// - https://github.com/Juanpe/SkeletonView/blob/30c92f0992888e7b249e788405ac31e2103f5c69/SkeletonViewCore/Sources/Internal/Helpers/AssociationPolicy.swift
// swiftlint:enable line_length
public enum AssociationPolicy {
  public static let assign = objc_AssociationPolicy.OBJC_ASSOCIATION_ASSIGN
  public static let copy = objc_AssociationPolicy.OBJC_ASSOCIATION_COPY
  public static let copyNonatomic = objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC
  public static let retain = objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN
  public static let retainNonatomic = objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC
}

extension AssociatedObjects {
  /// wrapper around `objc_getAssociatedObject`
  /// - Parameter key: 연관 객체를 가져올 때 사용할 키 문자열이며, 고유해야합니다.
  /// - Returns: 해당 키와 연관된 객체가 있으면 그 객체를 반환하고, 없으면 nil을 반환합니다.
  public func ao_get(key: String) -> Any? {
    guard let unsafeRawPointerKey = UnsafeRawPointer(bitPattern: key.hashValue)
    else { return nil }
      
    return objc_getAssociatedObject(self, unsafeRawPointerKey)
  }
  
  /// wrapper around `objc_setAssociatedObject`
  /// - Parameters:
  ///   - value: 연관시킬 값
  ///   - key: 값을 연관시킬 때 사용할 키 문자열이며, 고유해야합니다.
  ///   - policy: 연관 객체의 메모리 관리 정책, 기본값은 `retainNonatomic`
  public func ao_set(
    _ value: Any,
    key: String,
    policy: objc_AssociationPolicy = AssociationPolicy.retainNonatomic
  ) {
    guard let unsafeRawPointerKey = UnsafeRawPointer(bitPattern: key.hashValue)
    else { return }
    
    objc_setAssociatedObject(self, unsafeRawPointerKey, value, policy)
  }
  
  /// wrapper around `objc_setAssociatedObject`
  /// - Parameters:
  ///   - value: 연관시킬 값
  ///   - key: 값을 연관시킬 때 사용할 키 문자열이며, 고유해야합니다.
  ///   - policy: 연관 객체의 메모리 관리 정책, 기본값은 `retainNonatomic`
  public func ao_setOptional(
    _ value: Any?,
    key: String,
    policy: objc_AssociationPolicy = AssociationPolicy.retainNonatomic
  ) {
    guard let unsafeRawPointerKey = UnsafeRawPointer(bitPattern: key.hashValue)
    else { return }
    
    objc_setAssociatedObject(self, unsafeRawPointerKey, value, policy)
  }
}
