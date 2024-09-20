//
//  ApplicationServiceWorker.swift
//
//
//  Created by Wood on 9/13/24.
//

import Foundation

// 앱스토어 이동 및 Info.plist의 정보를 받아오는 Worker입니다.
// 해당 Domain Context Worker 구현이 완료되면 삭제될 예정입니다.
struct ApplicationServiceWorker {
  func fetchAppVersion() -> String? {
    return Bundle.main.infoDictionary?[ApplicationServiceWorker.bundleVersionKey] as? String
  }
}

extension ApplicationServiceWorker {
  static let bundleVersionKey = "CFBundleShortVersionString"
}
