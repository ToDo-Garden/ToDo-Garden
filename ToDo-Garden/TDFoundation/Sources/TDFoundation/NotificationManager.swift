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

  public func makeFocusNotification(after seconds: Double) {
    makeNotification(seconds: seconds, isFocus: true)
  }

  public func makeRestNotification(after seconds: Double) {
    self.makeNotification(seconds: seconds, isFocus: false)
  }

  public func clearPendingNotifications() {
    UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
  }
}

// MARK: Private Functions

extension NotificationManager {
  private func makeNotification(seconds: Double, isFocus: Bool) {
    let notiContent = UNMutableNotificationContent()
    let constant = NotificationManager.Constant.self
    notiContent.title = constant.title
    notiContent.body = isFocus ? constant.focusBody : constant.restBody

    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: seconds, repeats: false)
    let identifier = isFocus ? constant.focusIdentifier : constant.restIdentifier
    let request = UNNotificationRequest(identifier: identifier, content: notiContent, trigger: trigger)

    UNUserNotificationCenter.current().add(request)
  }
}

public enum NotificationPermissionError: Error {
  case unknownError
}

// MARK: Constant

extension NotificationManager {
  enum Constant {
    static let title = "ToDo Garden"
    static let focusBody = "수고했어요! 오늘도 열심히 집중한 당신!"
    static let restBody = "충전완료! 이제 다시 열심히 힘을 내볼까요?"
    static let focusIdentifier = "focusComplete"
    static let restIdentifier = "restComplete"
  }
}
