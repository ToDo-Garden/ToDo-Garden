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
  
  @Test("값 변경 테스트")
  func valueChange() async {
    // Given
    let expectedValue = 2
    let initialValue = 10
    @DynamicProperty var intValue = initialValue
    
    await confirmation(expectedCount: 2) { confirmation in
      _intValue.projectedValue { value in
        // Then
        if value == initialValue || value == expectedValue {
          #expect(true)
        }
        confirmation()
      }
      // When
      intValue = expectedValue
    }
  }
}
