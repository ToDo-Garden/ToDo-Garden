//
//  AppDelegate.swift
//  ToDo-Garden
//
//  Created by Noah on 1/10/24.
//

import UIKit

import TDFoundation
import ToDoGardenUIComponent

import ToDoGardenUIResource

import SharingGRDB

// swiftlint:disable force_try
@main
final class AppDelegate: UIResponder, UIApplicationDelegate {
  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
  ) -> Bool {
    self.prepare()

    return true
  }
  
  private func prepare() {
    NavigationBarUIUpdator.update()
    self.registerCustomFonts()
    prepareDependencies {
      $0.defaultDatabase = try! appDatabase()
    }
    UNUserNotificationCenter.current().delegate = NotificationManager.shared
  }
  
  private func registerCustomFonts() {
    PretendardFont.register()
    GmarkSansFont.register()
  }
}
// swiftlint:enable force_try
