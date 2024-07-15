//
//  DynamicPropertyTests.swift
//  TDUtility
//
//  Created by Noah on 7/15/24.
//

@testable import TDUtility
import Testing

@Suite("DynamicPropertyTests")
struct DynamicPropertyTests {
  @Test("초기화 테스트")
  private func initialization() {
    @DynamicProperty var intValue = 1
    #expect(_intValue.wrappedValue == 1)
    
    intValue = 2
    #expect(_intValue.wrappedValue == 2)
  }
}
