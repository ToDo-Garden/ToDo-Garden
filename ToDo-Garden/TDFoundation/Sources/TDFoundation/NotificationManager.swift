//
//  NotificationManager.swift
//
//
//  Created by Wood on 2/8/25.
//

import Foundation
import UserNotifications

public final class NotificationManager {
  public init() {}

  /// 현재 사용자가 설정한 알림 설정 권한을 가져오는 메서드입니다.
  /// 권한이 허용되어있으면 true, 거부되어 있으면 false를 반환합니다.
  public func fetchPermission() async throws -> Bool {
    let notificationCenter = UNUserNotificationCenter.current()
    let settings = await notificationCenter.notificationSettings()
    switch settings.authorizationStatus {
    case .authorized:
      return true
    case .denied:
      return false
    case .notDetermined:
      let options: UNAuthorizationOptions = [.alert, .badge, .sound]
      return try await notificationCenter.requestAuthorization(options: options)
    default:
      throw NotificationPermissionError.unknownError
    }
  }
}

public enum NotificationPermissionError: Error {
  case unknownError
}
