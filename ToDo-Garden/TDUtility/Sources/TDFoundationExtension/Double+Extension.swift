import Foundation

public extension Double {
  var hour: Double {
    return self / 3600
  }
  
  /// - Parameter subtractHours: true이면 전체 초에서 시간을 제외한 잔여 분을 반환하고, false이면 전체 초를 분 단위로 반환합니다.
  func minute(_ subtractHours: Bool = true) -> Double {
    subtractHours
    ? floor((self.truncatingRemainder(dividingBy: 3600)) / 60)
    : floor(self / 60)
  }
}
