//
//  NotificationManager.swift
//
//
//  Created by Wood on 2/8/25.
//

import Foundation
import UserNotifications

public final class NotificationManager: NSObject, Sendable, UNUserNotificationCenterDelegate {
  public static let shared = NotificationManager()

  private override init() {}

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
    self.makeNotification(NotificationType.focus(seconds))
  }

  public func makeRestNotification(after seconds: Double) {
    self.makeNotification(NotificationType.rest(seconds))
  }
  
  public func pushDailyToDoReminder(count: Int) {
    self.makeNotification(NotificationType.dailyToDoReminder(count))
  }

  public func clearPendingNotifications() {
    UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
  }
}

extension NotificationManager {
  public func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    willPresent notification: UNNotification
  ) async -> UNNotificationPresentationOptions {
    return [.badge, .banner, .sound]
  }
}

// MARK: Private Functions

extension NotificationManager {
  enum NotificationType {
    var body: String {
      switch self {
      case .focus:
        return Constant.focusBody
      case .rest:
        return Constant.restBody
      case .dailyToDoReminder(let count):
        return "아직 완료 하지 않은 ToDo가 \(count)개 남아있어요!"
      }
    }
    
    var delay: Double {
      switch self {
      case .focus(let seconds), .rest(let seconds):
        return seconds
      case .dailyToDoReminder:
        return 0.1
      }
    }
    
    var identifier: String {
      switch self {
      case .focus:
        return Constant.focusIdentifier
      case .rest:
        return Constant.restIdentifier
      case .dailyToDoReminder:
        return Constant.dailyToDoReminderIdentifier
      }
    }
    
    case focus(Double)
    case rest(Double)
    case dailyToDoReminder(Int)
  }
  
  private func makeNotification(_ type: NotificationType) {
    let notiContent = UNMutableNotificationContent()
    let constant = NotificationManager.Constant.self
    notiContent.title = constant.title
    notiContent.body = type.body

    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: type.delay, repeats: false)
    let request = UNNotificationRequest(identifier: type.identifier, content: notiContent, trigger: trigger)

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
    static let dailyToDoReminderIdentifier = "dailyToDoReminderComplete"
  }
}
