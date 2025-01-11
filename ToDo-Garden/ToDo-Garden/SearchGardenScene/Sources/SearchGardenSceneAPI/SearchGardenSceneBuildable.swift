//
//  SearchGardenSceneBuildable.swift
//  
//
//  Created by SONG on 11/18/24.
//  Copyright (c) 2024 ToDoGarden. All rights reserved.

import Foundation

public protocol SearchGardenSceneBuildable {
  ///  VIP Cycle, 런타임 파라미터가 설정된 ViewController 인스턴스를 반환하는 함수입니다.
  /// - Parameter payload: 런타임에 전달받아야 하는 파라미터입니다.
  /// - Returns: 런타임 파라미터, VIP Cycle이 설정된 ViewController가 반환되도록 구현합니다.
  func build() -> SearchGardenViewControllable
}
