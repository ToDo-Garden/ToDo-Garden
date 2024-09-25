//
//  ApplicationServiceWorker.swift
//
//
//  Created by Wood on 9/13/24.
//

import Foundation

// 앱스토어 이동 및 Info.plist의 정보를 받아오는 Worker입니다.
// 해당 Domain Context Worker 구현이 완료되면 삭제될 예정입니다.
public struct ApplicationServiceWorker {
  func fetchCurrentAppVersion() -> String? {
    return Bundle.main.infoDictionary?[ApplicationServiceWorker.bundleVersionKey] as? String
  }

  /// 버전 업데이트 필요 여부를 반환하는 메서드입니다.
  /// 네트워크 통신이 필요하므로, Network Service 레이어 구현이 완료되면 추가 구현할 예정입니다.
  func isUpdateAvailable() async -> Bool {
    return false
  }

  /// 업데이트를 위해 앱스토어로 이동하는 메서드입니다.
  /// 앱스토어에 앱이 등재된 이후, 내부 구현을 할 예정입니다.
  func openAppStore() {}
}

extension ApplicationServiceWorker {
  static let bundleVersionKey = "CFBundleShortVersionString"
}
