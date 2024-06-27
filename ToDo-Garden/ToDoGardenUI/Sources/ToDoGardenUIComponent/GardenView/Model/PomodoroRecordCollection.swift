//
//  PomodoroRecordCollection.swift
//
//
//  Created by Noah on 6/26/24.
//

import Foundation

/// PomodoroRecord 객체를 저장하는 first class collection입니다.
public struct PomodoroRecordCollection {
  private var pomodoroRecords: [PomodoroRecord]
  private var maxPomodoroCount: Int?
  
  public init(pomodoroRecords: [PomodoroRecord] = [PomodoroRecord]()) {
    self.pomodoroRecords = pomodoroRecords
    self.maxPomodoroCount = self.pomodoroRecords.max { lhs, rhs in
      lhs.pomodoroCount < rhs.pomodoroCount
    }?.pomodoroCount
  }
  
  /// 뽀모도로 횟수에 따라 정규화된 PomodoroLevel의 배열을 반환하는 메서드입니다.
  /// - Returns: 뽀모도로 횟수에 따라 정규화된 PomodoroLevel의 배열을 반환합니다.
  func normalizedPomodoroLevels() -> [PomodoroLevel] {
    return self.pomodoroRecords.map { self.normalizedPomodoroLevel(for: $0.pomodoroCount) }
  }

extension PomodoroRecordCollection {
  /// `count`에 따라 `none`~`perfect` 단계에 해당하는 `PomodoroLevel`로 정규화합니다.
  /// - Parameter count: Pomodoro를 수행한 횟수를 받습니다.
  /// - Returns: `count`에 따라 정규화된 `PomodoroLevel` 타입을 반환합니다.
  private func normalizedPomodoroLevel(for count: Int) -> PomodoroLevel {
    guard count != 0,
      let maxPomodoroCount = self.maxPomodoroCount
    else { return PomodoroLevel.none }
    
    let levels: [PomodoroLevel] = [PomodoroLevel.low, PomodoroLevel.middle, PomodoroLevel.high, PomodoroLevel.perfect]
    let step: Float = Float(maxPomodoroCount) / Float((levels.count - 1))
    let levelIndex = min(Int(Float(count) / Float(step)), levels.count - 1)
    
    if levelIndex > 3 {
      return PomodoroLevel.perfect
    }
    
    if levelIndex < 0 {
      return PomodoroLevel.none
    }
    
    return levels[levelIndex]
  }
}
