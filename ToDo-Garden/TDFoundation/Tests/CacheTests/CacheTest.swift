@preconcurrency import Combine
import Foundation
import Testing
import UIKit

import TDFoundation

// swiftlint:disable identifier_name
@MainActor
struct CacheTest {
  @Test func immediateCancellation() async throws {
    let cache = Cache(request: TestNetworkClient())
    await confirmation(expectedCount: 10) { confirmation in
      var tasks: [Task<Void, Never>] = []
      for i in 1...10 {
        let task = Task {
          do {
            _ = try await cache.execute(id: 3)
          } catch {
            confirmation()
          }
        }
        if i == 5 {
          task.cancel()
        }
        tasks.append(task)
      }
      
      for task in tasks {
        _ = await task.value
      }
    }
  }
  
  @Test func delayedCancellation() async throws {
    let cache = Cache(request: TestNetworkClient())
    await confirmation(expectedCount: 10) { confirmation in
      var tasks: [Task<Void, Never>] = []
      for _ in 1...10 {
        let task = Task {
          do {
            _ = try await cache.execute(id: 3)
          } catch {
            confirmation()
          }
        }
        tasks.append(task)
      }
      Task {
        try await Task.sleep(nanoseconds: 100)
        cache.cancel(id: 3)
      }
      
      for task in tasks {
        _ = await task.value
      }
    }
  }
  
  @Test func singleCancellation() async throws {
    let cache = Cache(request: TestNetworkClient())
    await confirmation(expectedCount: 1) { confirmation in
      let task = Task {
        do {
          _ = try await cache.execute(id: 3)
        } catch {
          confirmation()
        }
      }
      
      Task {
        try await Task.sleep(nanoseconds: 100)
        cache.cancel(id: 3)
      }
      
      _ = await task.value
    }
  }
  
  @Test func memoryWarning() async throws {
    let subject = PassthroughSubject<Void, Never>()
    let cache = Cache(
      request: TestNetworkClient(),
      dependency: .overrideMemoryWarning(subject)
    )
    _ = try await cache.execute(id: 3)
    #expect(await cache.isCached(id: 3))
    subject.send(())
    await superYield()
    #expect(await !cache.isCached(id: 3))
  }
  
  // 테스트코드 환경에서 타이머의 경우 오동작하는 경우가 있음. 이를 테스트하기 위해선, 다른 조치가 필요함.
  // CombineSchedulers를 사용하면 좋음.
  //  @Test func expiredCachedItem() async throws {
  //    let temp = Cache(
  //      request: TestNetworkClient(),
  //      configuration: .init(expiration: .seconds(0.2), cleanupInterval: 0.3)
  //    )
  //    _ = try await temp.execute(id: 3)
  //    #expect(await temp.isCached(id: 3))
  //    try await Task.sleep(for: .seconds(0.3))
  //    #expect(await !temp.isCached(id: 3))
  //  }
  
  func superYield() async {
    for _ in 1...100 {
      await Task.yield()
    }
  }
  
  @Test func memoryCostOver() async throws {
    let cache = Cache(
      request: TestNetworkClient(),
      configuration: .init(limit: .init(value: 50, unit: .bytes))
    )
    for i in 1...3 {
      do {
        _ = try await cache.execute(id: i)
      } catch {
        print(error)
      }
    }
    await confirmation(expectedCount: 2) { confirmation in
      for i in 1...3 where await cache.isCached(id: i) {
        confirmation()
      }
    }
  }
}

struct TestNetworkClient: Requestable {
  func execute(id: Int) async throws -> String {
    try await Task.sleep(nanoseconds: 50_000_000)
    return "id \(id)"
  }
}

extension String: MemorySizeProvider {
  public var estimatedMemory: Measurement<UnitInformationStorage> {
    .init(value: 20, unit: .bytes)
  }
}

extension Cache.Dependecny {
  static func overrideMemoryWarning(
    _ subject: PassthroughSubject<Void, Never>
  ) -> Self {
    var live = Self.liveValue
    live.memoryWarningStream = {
      subject
        .eraseToAnyPublisher()
    }
    return live
  }
}
// swiftlint:enable identifier_name
