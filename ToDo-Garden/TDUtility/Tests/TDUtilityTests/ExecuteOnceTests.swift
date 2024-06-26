@testable import TDUtility
import Testing

@Suite("ExecuteOnceTests")
struct ExecuteOnceTests {
  
  @Test("when action is set multiple times then it executes once")
  private func whenActionIsSetMultipleTimes_thenItExecutesOnlyOnce() {
    var executionCount = 0
    @ExecuteOnce var action: (() -> Void)?
    
    action = {
      executionCount += 1
    }
    #expect(executionCount == 1)
    
    action = {
      executionCount += 1
    }
    #expect(
      executionCount == 1,
      "한번만 실행되어야합니다."
    )
  }
  
  @Test("when action execute multiple times then it executes only once")
  private func whenActionExecuteMultipleTimes_thenItExecutesOnlyOnce() {
    var executionCount = 0
    @ExecuteOnce var action: (() -> Void)?
    
    action?()
    
    action = {
      executionCount += 1
    }
    #expect(executionCount == 1)
    
    action?()
    action?()
    action?()
    #expect(
      executionCount == 1,
      "한번만 실행되어야합니다."
    )
  }
}
