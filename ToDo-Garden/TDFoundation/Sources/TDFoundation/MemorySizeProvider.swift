import Foundation

public protocol MemorySizeProvider: Sendable {
  var estimatedMemory: Measurement<UnitInformationStorage> { get throws }
}

extension Measurement where UnitType == UnitInformationStorage {
  var cost: Int {
    Int(converted(to: .bytes).value)
  }
}
