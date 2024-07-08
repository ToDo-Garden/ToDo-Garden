//
//  PostGroupSceneBuildable.swift
//  
//
//  Created by SONG on 7/8/24.
//  Copyright (c) 2024 ToDoGarden. All rights reserved.

import Foundation

/// 런타임에 전달받을 의존성을 선언한 구조체입니다.
public protocol PostGroupScenePayloadable {
  // var name: String { get }
}

public protocol PostGroupSceneBuildable {
  ///  VIP Cycle, 런타임 파라미터가 설정된 ViewController 인스턴스를 반환하는 함수입니다.
  /// - Parameter payload: 런타임에 전달받아야 하는 파라미터입니다.
  /// - Returns: 런타임 파라미터, VIP Cycle이 설정된 ViewController가 반환되도록 구현합니다.
  func build(with payload: PostGroupScenePayloadable) -> PostGroupViewControllable
}
