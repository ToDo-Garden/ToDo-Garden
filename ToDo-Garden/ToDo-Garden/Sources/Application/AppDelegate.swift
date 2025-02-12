//
//  AppDelegate.swift
//  ToDo-Garden
//
//  Created by Noah on 1/10/24.
//

import UIKit

import ToDoGardenUIResource

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {
  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
  ) -> Bool {
    registerCustomFonts()
    UNUserNotificationCenter.current().delegate = self
    return true
  }
}

extension AppDelegate {
  private func registerCustomFonts() {
    PretendardFont.register()
    GmarkSansFont.register()
  }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
  func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    willPresent notification: UNNotification
  ) async -> UNNotificationPresentationOptions {
    return [.badge, .banner, .sound]
  }
}
