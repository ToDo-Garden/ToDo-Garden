import Foundation

public protocol MemorySizeProvider: Sendable {
  var estimatedMemory: Measurement<UnitInformationStorage> { get throws }
}

extension Measurement<UnitInformationStorage> {
  @usableFromInline
  static let memoryLimit: Self = {
    let totalMemory = ProcessInfo.processInfo.physicalMemory
    let limit = totalMemory / 4
    let costLimit = (limit > UInt64(Int.max)) ? UInt64(Int.max) : limit
    return .init(value: Double(costLimit), unit: .bytes)
  }()
}
